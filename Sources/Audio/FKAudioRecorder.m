#import "FKAudioRecorder.h"


@interface FKAudioRecorder ()

- (OSStatus)configureAU;
- (OSStatus)configureOutputFile;

static OSStatus AudioRecorderPrintErrorAndReturn(OSStatus err, OSStatus status);
static AudioDeviceID AudioRecorderGetDefaultInputDevice();
static void AudioRecorderDestroyAudioBufferList(AudioBufferList *bufList);
static AudioBufferList * AudioRecorderAllocateAudioBufferList(UInt32 numChannels, UInt32 size);
static OSStatus AudioRecorderAURenderCallback(void *refcon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData);

@end


@implementation FKAudioRecorder

- (id)initWithOutputFile:(NSString *)path format:(AudioStreamBasicDescription)format {
  if ((self = [super init])) {
    inputDeviceID_ = 0;
    audioChannels_ = 0;
    audioSamples_ = 0;
    fileFormat_ = format;
    fileURL_ = CFURLCreateWithFileSystemPath(NULL, (__bridge CFStringRef)path, kCFURLPOSIXPathStyle, false);
  }
  return self;
}

- (void)dealloc {
  // Stop recording
  [self stop];
  
  // Release file URL
  if (fileURL_) {
    CFRelease(fileURL_);
    fileURL_ = NULL;
  }
  
  // Dispose audio output file
  if (outputFile_) {
    ExtAudioFileDispose(outputFile_);
    outputFile_ = NULL;
  }
}

- (NSURL *)outputFileURL {
  return (__bridge NSURL *)fileURL_;
}

- (OSStatus)configure {
  // Configure the audio unit
  //
  // Technical Note TN2091 "Device input using the HAL Output Audio Unit":
  // http://developer.apple.com/library/mac/#technotes/tn2091/_index.html
  //
  OSStatus status = [self configureAU];
  if (status) {
    printf("error configuring AU (%d)\n", status);
    return status;
  }
  
  // Configure the output file
  status = [self configureOutputFile];
  if (status) {
    printf("error configuring output file (%d)\n", status);
  }
  return status;
}

- (OSStatus)start {
  return AudioOutputUnitStart(audioUnit_);
}

- (OSStatus)stop {
  return AudioOutputUnitStop(audioUnit_); 
}

typedef enum {
  kARAudioUnitErrorCantFindComponent = 'nocp',
  kARAudioUnitErrorCantCreateAUInstance = 'inst',
  kARAudioUnitErrorCantEnableAUHALInput = 'auin',
  kARAudioUnitErrorCantDisableAUHALOutput = 'auou',
  kARAudioUnitErrorNoDefaultInputFound = 'noin',
  kARAudioUnitErrorCantSetDefaultInputDevice = 'devs',
  kARAudioUnitErrorCantSetRenderCallback = 'rncb',
  kARAudioUnitErrorCantRenderInput = 'rend',
  kARAudioUnitErrorCantGetInputDeviceFormat = 'ifmt',
  kARAudioUnitErrorCantSetOutputDeviceFormat = 'ofmt',
  kARAudioUnitErrorCantGetIOBufferFrameSize = 'samp',
  kARAudioUnitErrorCantInitialize = 'init',
  kARAudioUnitErrorCantAllocateBufferList = 'bufl'
} ARAudioUnitError;

- (OSStatus)configureAU {
  OSStatus status;
  AudioComponent comp;
  AudioComponentDescription desc;
  
  // There are several different types of Audio Units.
  // Some audio units serve as Outputs, Mixers, or DSP
  // units. See AUComponent.h for listing
  desc.componentType = kAudioUnitType_Output;
  
  // Every Component has a subType, which will give a clearer picture
  // of what this components function will be.
  desc.componentSubType = kAudioUnitSubType_HALOutput;
  
  // All Audio Units in AUComponent.h must use 
  // "kAudioUnitManufacturer_Apple" as the Manufacturer
  desc.componentManufacturer = kAudioUnitManufacturer_Apple;
  desc.componentFlags = 0;
  desc.componentFlagsMask = 0;
  
  // Finds a component that meets the desc spec's
  comp = AudioComponentFindNext(NULL, &desc);
  if (comp == NULL) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantFindComponent, 0);
  }
  
  // Gains access to the services provided by the component
  status = AudioComponentInstanceNew(comp, &audioUnit_);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantCreateAUInstance, status);
  }
  
  // Enable input on AUHAL and disable output
  UInt32 param = 1;
  status = AudioUnitSetProperty(audioUnit_, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Input, 1, &param, sizeof(UInt32));
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantEnableAUHALInput, status);
  }
  
  param = 0;
  status = AudioUnitSetProperty(audioUnit_, kAudioOutputUnitProperty_EnableIO, kAudioUnitScope_Output, 0, &param, sizeof(UInt32));
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantDisableAUHALOutput, status);
  }
  
  // Select the default input device
  // 
  // Technical Note TN2223 "Moving Off Deprecated HAL APIs":
  // http://developer.apple.com/library/mac/#technotes/tn2223/_index.html
  //
  inputDeviceID_ = AudioRecorderGetDefaultInputDevice();
  if (inputDeviceID_ == 0) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorNoDefaultInputFound, 0);
  }
  
  // Set the default input device on the AU
  status = AudioUnitSetProperty(audioUnit_, kAudioOutputUnitProperty_CurrentDevice, kAudioUnitScope_Global, 0, &inputDeviceID_, sizeof(AudioDeviceID));
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantSetDefaultInputDevice, status);
  }
  
  // Setup render callback
  AURenderCallbackStruct callback = {
    AudioRecorderAURenderCallback,
    (__bridge void *)self
  };
  status = AudioUnitSetProperty(audioUnit_, kAudioOutputUnitProperty_SetInputCallback, kAudioUnitScope_Global, 0, &callback, sizeof(AURenderCallbackStruct));
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantSetRenderCallback, status);
  }
  
  // Get the hardware device format and set the output format
  param = sizeof(AudioStreamBasicDescription);
  status = AudioUnitGetProperty(audioUnit_, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 1, &deviceFormat_, &param);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantGetInputDeviceFormat, status);
  }
  
  audioChannels_ = MAX(deviceFormat_.mChannelsPerFrame, 2);
  
  memset(&outputFormat_, 0, sizeof(AudioStreamBasicDescription));
  outputFormat_.mChannelsPerFrame = audioChannels_;
  outputFormat_.mSampleRate = deviceFormat_.mSampleRate;
  outputFormat_.mFormatID = kAudioFormatLinearPCM;
  outputFormat_.mFormatFlags = kAudioFormatFlagIsFloat | kAudioFormatFlagIsPacked | kAudioFormatFlagIsNonInterleaved;
  if (outputFormat_.mFormatID == kAudioFormatLinearPCM && audioChannels_ == 1) {
    outputFormat_.mFormatFlags &= ~kLinearPCMFormatFlagIsNonInterleaved;
  }
#if __BIG_ENDIAN__
  m_outputFormat.mFormatFlags |= kAudioFormatFlagIsBigEndian;
#endif
  outputFormat_.mBitsPerChannel = sizeof(Float32) * 8;
  outputFormat_.mBytesPerFrame = outputFormat_.mBitsPerChannel / 8;
  outputFormat_.mFramesPerPacket = 1;
  outputFormat_.mBytesPerPacket = outputFormat_.mBytesPerFrame;
  
  status = AudioUnitSetProperty(audioUnit_, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 1, &outputFormat_, sizeof(AudioStreamBasicDescription));
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantSetOutputDeviceFormat, status);
  }
  
  // Get the IO buffer frame count
  param = sizeof(UInt32);
  status = AudioUnitGetProperty(audioUnit_, kAudioDevicePropertyBufferFrameSize, kAudioUnitScope_Global, 0, &audioSamples_, &param);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantGetIOBufferFrameSize, status);
  }
  
  // Initialize the AU
  status = AudioUnitInitialize(audioUnit_);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantInitialize, status);
  }
  
  // Allocate audio buffers
  bufferList_ = AudioRecorderAllocateAudioBufferList(outputFormat_.mChannelsPerFrame, audioSamples_ * outputFormat_.mBytesPerFrame);
  if (bufferList_ == NULL) {
    return AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantAllocateBufferList, 0);
  }
  
  return 0;
}

typedef enum {
  kAROutputFileErrorCantCreateFile = 'crea',
  kAROutputFileErrorCantSetOutputFormat = 'ffmt',
  kAROutputFileErrorCantCreateChannelMap = 'chan',
  kAROutputFileErrorCantWriteAsync = 'wasy'
} AROutputFileError;

- (OSStatus)configureOutputFile {
  OSStatus status;
  
  // Create new MP4 output file
  status = ExtAudioFileCreateWithURL(fileURL_, kAudioFileM4AType, &fileFormat_, NULL, kAudioFileFlags_EraseFile, &outputFile_);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kAROutputFileErrorCantCreateFile, status);
  }
  
  // Tell the file what input format to expect (should be PCM).
  // We must set this in order to encode or decode a non-PCM file data format.
  status = ExtAudioFileSetProperty(outputFile_, kExtAudioFileProperty_ClientDataFormat, sizeof(AudioStreamBasicDescription), &outputFormat_);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kAROutputFileErrorCantSetOutputFormat, status);
  }
  
  // If we are recording from a mono source, setup a simple channel map to split to stereo
  if (deviceFormat_.mChannelsPerFrame == 1 && outputFormat_.mChannelsPerFrame == 2) {
    UInt32 size = sizeof(AudioConverterRef);
    
    // Get the underlying AudioConverterRef.
    AudioConverterRef converter = NULL;
    status = ExtAudioFileGetProperty(outputFile_, kExtAudioFileProperty_AudioConverter, &size, &converter);
    if (converter) {
      // This should be as large as the number of output channels,
			// each element specifies which input channel's data is routed to that output channel.
      SInt32 channelMap[] = {0, 0};
      status = AudioConverterSetProperty(converter, kAudioConverterChannelMap, 2 * sizeof(SInt32), channelMap);
    }
  }
  
  if (status) {
    AudioRecorderPrintErrorAndReturn(kAROutputFileErrorCantCreateChannelMap, status);
  }
  
  // Prepare file for async IO
  status = ExtAudioFileWriteAsync(outputFile_, 0, NULL);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kAROutputFileErrorCantWriteAsync, status);
  }
  
  return 0;
}

#pragma mark Static C

static OSStatus AudioRecorderPrintErrorAndReturn(OSStatus err, OSStatus status) {
  const char *msg = "";
  switch (err) {
      // Audio unit errors
    case kARAudioUnitErrorCantFindComponent: msg = "cannot find AUHAL component"; break;
    case kARAudioUnitErrorCantCreateAUInstance: msg = "cannot create AU instance"; break;
    case kARAudioUnitErrorCantEnableAUHALInput: msg = "cannot enable AUHAL input"; break;
    case kARAudioUnitErrorCantDisableAUHALOutput: msg = "cannot disable AUHAL output"; break;
    case kARAudioUnitErrorNoDefaultInputFound: msg = "no default input founds"; break;
    case kARAudioUnitErrorCantSetDefaultInputDevice: msg = "cannot set default input on AU"; break;
    case kARAudioUnitErrorCantSetRenderCallback: msg = "cannot set render callback"; break;
    case kARAudioUnitErrorCantRenderInput: msg = "cannot render input to AU"; break;
    case kARAudioUnitErrorCantGetInputDeviceFormat: msg = "cannot get input device format"; break;
    case kARAudioUnitErrorCantSetOutputDeviceFormat: msg = "cannot get output device format"; break;
    case kARAudioUnitErrorCantGetIOBufferFrameSize: msg = "cannot get IO buffer frame size"; break;
    case kARAudioUnitErrorCantInitialize: msg = "cannot initialize AU"; break;
    case kARAudioUnitErrorCantAllocateBufferList: msg = "cannot allocate buffer list"; break;
      // Output file errors
    case kAROutputFileErrorCantCreateFile: msg = "cannot create output file"; break;
    case kAROutputFileErrorCantSetOutputFormat: msg = "cannot set output file format"; break;
    case kAROutputFileErrorCantCreateChannelMap: msg = "cannot create channel map"; break;
    case kAROutputFileErrorCantWriteAsync: msg = "cannot write output file async"; break;
  }
  printf("error '%s': %s (%d)\n", FKFcc(err), msg, status);
  return err;
}

static AudioDeviceID AudioRecorderGetDefaultInputDevice() {
  AudioDeviceID deviceID = 0;
  UInt32 propSize = sizeof(AudioDeviceID);
  AudioObjectPropertyAddress propAddress = {
    kAudioHardwarePropertyDefaultInputDevice,
    kAudioObjectPropertyScopeGlobal,
    kAudioObjectPropertyElementMaster
  };
  OSStatus status = AudioObjectGetPropertyData(kAudioObjectSystemObject,
                                               &propAddress,
                                               0,
                                               NULL,
                                               &propSize,
                                               &deviceID);
  if (status) {
    return 0;
  }
  return deviceID;
}

static void AudioRecorderDestroyAudioBufferList(AudioBufferList *bufList) {
	if(bufList) {
		for(UInt32 i = 0; i < bufList->mNumberBuffers; ++i) {
			if(bufList->mBuffers[i].mData) {
        free(bufList->mBuffers[i].mData);
      }
		}
		free(bufList);
	}
}

static AudioBufferList * AudioRecorderAllocateAudioBufferList(UInt32 numChannels, UInt32 size) {
	AudioBufferList *bufList = (AudioBufferList*)calloc(1, sizeof(AudioBufferList) + numChannels * sizeof(AudioBuffer));
	if(bufList == NULL) {
    return NULL;
  }
	
	bufList->mNumberBuffers = numChannels;
	for(UInt32 i=0; i<numChannels; ++i) {
		bufList->mBuffers[i].mNumberChannels = 1;
		bufList->mBuffers[i].mDataByteSize = size;
		bufList->mBuffers[i].mData = malloc(size);
		if(bufList->mBuffers[i].mData == NULL) {
			AudioRecorderDestroyAudioBufferList(bufList);
			return NULL;
		}
	}
	return bufList;
}

static OSStatus AudioRecorderAURenderCallback(void *refcon, AudioUnitRenderActionFlags *ioActionFlags, const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber, UInt32 inNumberFrames, AudioBufferList *ioData) {
  OSStatus status;
  FKAudioRecorder *context = (__bridge FKAudioRecorder *)refcon;
  
  // Render into audio buffer
  status = AudioUnitRender(context->audioUnit_, ioActionFlags, inTimeStamp, inBusNumber, inNumberFrames, context->bufferList_);
  if (status) {
    AudioRecorderPrintErrorAndReturn(kARAudioUnitErrorCantRenderInput, status);
  }
  
  // Write audio data to file. ExtAudioFile automatically handles format conversion and encoding.
  // NOTE: Async writes may not be flushed to disk until the file reference is
  // disposed using ExtAudioFileDispose.
  //
  status = ExtAudioFileWriteAsync(context->outputFile_, inNumberFrames, context->bufferList_);
  if (status) {
    return AudioRecorderPrintErrorAndReturn(kAROutputFileErrorCantWriteAsync, status);;
  }
  
  return 0;
}

@end
