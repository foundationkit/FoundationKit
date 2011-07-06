// Part of FoundationKit http://foundationk.it
//
// Derived from Erik Aigner's COAudioRecorder

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <AudioToolbox/AudioToolbox.h>


@interface NKAudioRecorder : NSObject {
@private
  CFURLRef                    fileURL_;
  AudioDeviceID               inputDeviceID_;
  UInt32                      audioChannels_;
  UInt32                      audioSamples_;
  AudioStreamBasicDescription fileFormat_;
  AudioStreamBasicDescription outputFormat_;
  AudioStreamBasicDescription deviceFormat_;
  ExtAudioFileRef             outputFile_;
  AudioUnit                   audioUnit_;
  AudioBufferList             *bufferList_;
}

@property (nonatomic, readonly) NSURL *outputFileURL;

- (id)initWithOutputFile:(NSString *)path format:(AudioStreamBasicDescription)format;

- (OSStatus)configure;
- (OSStatus)start;
- (OSStatus)stop;

@end
