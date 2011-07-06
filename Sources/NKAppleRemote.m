#import "NKAppleRemote.h"


#define NSSTR(str) (NSString *)CFSTR(str)

char * const kNKAppleRemoteDeviceName = "AppleIRController";

// Explicit queue layouts
//
#define kRemoteButtonPlay10_6 {2, 20, 21, 23, 33}
#define kRemoteButtonPlay10_6_Hold {2, 20, 21, 33, 37}
#define kRemoteButtonPlay10_6_Alu {2, 8, 20, 21, 33}
#define kRemoteButtonCenter10_6_Alu {2, 3, 20, 21, 33}
#define kRemoteButtonCenter10_6_Alu_Hold {2, 11, 20, 21, 33}
#define kRemoteButtonPlus10_6 {2, 20, 21, 30, 31, 33}
#define kRemoteButtonMinus10_6 {2, 20, 21, 30, 32, 33}
#define kRemoteButtonLeft10_6 {2, 20, 21, 25, 33}
#define kRemoteButtonLeft10_6_Hold {2, 12, 13, 20, 21, 33}
#define kRemoteButtonRight10_6 {2, 20, 21, 24, 33}
#define kRemoteButtonRight10_6_Hold {2, 12, 14, 20, 21, 33}
#define kRemoteButtonMenu10_6 {2, 20, 21, 22, 33}
#define kRemoteButtonMenu10_6_Hold {2, 20, 21, 33}

// Button state match
//
typedef struct nk_ar_match_t {
	int				id;
	int				state;
	uint32_t	cookieMatch[10];
	uint32_t	valueMatch[10];
} nk_ar_match_t;


// Remote button matching table
//
const nk_ar_match_t nk_ar_match_table[] = {
	{
		RKAppleRemoteButtonCenter,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonCenter10_6_Alu,
		{1, 1}
	},
	{
		RKAppleRemoteButtonCenter,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonCenter10_6_Alu,
		{0}
	},
	{
		RKAppleRemoteButtonCenter,
		RKAppleRemoteButtonStateHoldDown,
		kRemoteButtonCenter10_6_Alu_Hold,
		{9, 1}
	},
	{
		RKAppleRemoteButtonCenter,
		RKAppleRemoteButtonStateHoldUp,
		kRemoteButtonCenter10_6_Alu_Hold,
		{0}
	},
	{
		RKAppleRemoteButtonPlay,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonPlay10_6,
		{6, 1}
	},
	{
		RKAppleRemoteButtonPlay,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonPlay10_6,
		{0}
	},
	{
		RKAppleRemoteButtonPlay,
		RKAppleRemoteButtonStateHoldDown,
		kRemoteButtonPlay10_6_Hold,
		{0, 0, 0, 4, 1}
	},
	{
		RKAppleRemoteButtonPlay,
		RKAppleRemoteButtonStateHoldUp,
		kRemoteButtonPlay10_6_Hold,
		{0}
	},
	{
		RKAppleRemoteButtonPlay,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonPlay10_6_Alu,
		{6, 1}
	},
	{
		RKAppleRemoteButtonPlay,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonPlay10_6_Alu,
		{0}
	},
	{
		RKAppleRemoteButtonMenu,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonMenu10_6,
		{0, 0, 1, 1}
	},
	{
		RKAppleRemoteButtonMenu,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonMenu10_6,
		{0}
	},
	{
		RKAppleRemoteButtonMenu,
		RKAppleRemoteButtonStateHoldDown,
		kRemoteButtonMenu10_6_Hold,
		{0, 1}
	},
	{
		RKAppleRemoteButtonMenu,
		RKAppleRemoteButtonStateHoldUp,
		kRemoteButtonMenu10_6_Hold,
		{0}
	},
	{
		RKAppleRemoteButtonLeft,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonLeft10_6,
		{0, 0, 4, 1}
	},
	{
		RKAppleRemoteButtonLeft,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonLeft10_6,
		{0}
	},
	{
		RKAppleRemoteButtonLeft,
		RKAppleRemoteButtonStateHoldDown,
		kRemoteButtonLeft10_6_Hold,
		{0, 1, 1}
	},
	{
		RKAppleRemoteButtonLeft,
		RKAppleRemoteButtonStateHoldUp,
		kRemoteButtonLeft10_6_Hold,
		{0}
	},
	{
		RKAppleRemoteButtonRight,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonRight10_6,
		{0, 0, 3, 1}
	},
	{
		RKAppleRemoteButtonRight,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonRight10_6,
		{0}
	},
	{
		RKAppleRemoteButtonRight,
		RKAppleRemoteButtonStateHoldDown,
		kRemoteButtonRight10_6_Hold,
		{0, 2, 1}
	},
	{
		RKAppleRemoteButtonRight,
		RKAppleRemoteButtonStateHoldUp,
		kRemoteButtonRight10_6_Hold,
		{0}
	},
	{
		RKAppleRemoteButtonPlus,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonPlus10_6,
		{0, 0, 0, 1, 1}
	},
	{
		RKAppleRemoteButtonPlus,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonPlus10_6,
		{0}
	},
	{
		RKAppleRemoteButtonMinus,
		RKAppleRemoteButtonStateDown,
		kRemoteButtonMinus10_6,
		{0, 0, 0, 2, 1}
	},
	{
		RKAppleRemoteButtonMinus,
		RKAppleRemoteButtonStateUp,
		kRemoteButtonMinus10_6,
		{0}
	}
};

#define kNKAppleRemoteMatchTableLen 26

static void nk_ar_secure_input_notification(void *refcon, io_service_t	service, uint32_t messageType, void *messageArgument);
static void nk_ar_hid_input_value_callback(void *context, IOReturn result, void *sender, IOHIDValueRef value);
static void nk_ar_queue_clear(uint32_t *q, int qlen);
static int nk_ar_queue_len(uint32_t q[]);
static void nk_ar_queue_put(uint32_t val, uint32_t *q, int qlen);

@interface NKAppleRemote ()

- (void)buttonEventPosted:(RKAppleRemoteButton)buttonId state:(RKAppleRemoteButtonState)state;

@end

@implementation NKAppleRemote
@synthesize delegate;
@synthesize exclusive;

+ (NSString *)nameForButton:(RKAppleRemoteButton)button {
	switch (button) {
		case RKAppleRemoteButtonPlay: return @"Play";
		case RKAppleRemoteButtonCenter: return @"Center";
		case RKAppleRemoteButtonPlus: return @"Plus";
		case RKAppleRemoteButtonMinus: return @"Minus";
		case RKAppleRemoteButtonLeft: return @"Left";
		case RKAppleRemoteButtonRight: return @"Right";
		case RKAppleRemoteButtonMenu: return @"Menu";
		default: return nil;
	}
}

- (id)init {
	if (self = [super init]) {
		self.exclusive = YES;
		
		// Deal with secure input glitch
		sinPort = IONotificationPortCreate(kIOMasterPortDefault);
		if (sinPort) {
			io_registry_entry_t entry = IORegistryEntryFromPath(kIOMasterPortDefault, kIOServicePlane ":/");
			if (entry) {
				kern_return_t result = IOServiceAddInterestNotification(sinPort,
																																entry,
																																kIOBusyInterest,
																																&nk_ar_secure_input_notification,
																																(__bridge void *)self,
																																&sinNotification);
				if (result) {
					NSLog(@"Error: failed to register for ESI notification");
					IONotificationPortDestroy(sinPort);
					sinPort = NULL;
				}
				else {
					CFRunLoopSourceRef source = IONotificationPortGetRunLoopSource(sinPort);
					CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
				}
				
				IOObjectRelease(entry);
			}
		}
		flags.sin = [self secureEventInputEnabled];
	}
	
	return self;
}

- (void)dealloc {
	IONotificationPortDestroy(sinPort);
	IOObjectRelease(sinNotification);
	sinPort = NULL;
	sinNotification = MACH_PORT_NULL;
	
	[self closeDevice];	
}

static void nk_ar_queue_put(uint32_t val, uint32_t *q, int qlen) {
	for (int i=qlen-1; i>0; i--) {
		q[i] = q[i-1];
	}
	q[0] = val;
}

static void nk_ar_queue_clear(uint32_t *q, int qlen) {
	for (int i=0; i<qlen; i++) {
		q[i] = 0;
	}
}

static int nk_ar_queue_len(uint32_t q[]) {
	int i = 0;
	uint32_t val = 0;
	do {
		val = q[i];
		i++;
	} while (val > 0);
	
	return (i-1);
}

static void nk_ar_hid_input_value_callback(void *context, IOReturn result, void *sender, IOHIDValueRef value) {
	NKAppleRemote *remote = (__bridge NKAppleRemote *)context;
	IOHIDElementRef element = IOHIDValueGetElement(value);
	IOHIDElementCookie cookie = IOHIDElementGetCookie(element);
	CFIndex intValue = IOHIDValueGetIntegerValue(value);
	
	// Put cookie in queue
	uint32_t cookieQueueLen = sizeof(remote->queue.cookie)/sizeof(uint32_t);
	uint32_t valueQueueLen = sizeof(remote->queue.value)/sizeof(uint32_t);
	
	nk_ar_queue_put((uint32_t)cookie, remote->queue.cookie, cookieQueueLen);
	nk_ar_queue_put((uint32_t)intValue, remote->queue.value, valueQueueLen);
	
	// Match button
	for (int i=0; i<kNKAppleRemoteMatchTableLen; i++) {
		nk_ar_match_t m = nk_ar_match_table[i];
		
		int cnt = 0;
		int qlen = nk_ar_queue_len(m.cookieMatch);
		
		for (int n=0; n<qlen; n++) {
			cnt += (m.cookieMatch[n] == remote->queue.cookie[n]);
			cnt += (m.valueMatch[n] == remote->queue.value[n]);
		}
		
		int found = (cnt == qlen*2);		
		if (found) {
			// Dispatch event to delegate
			[remote buttonEventPosted:m.id state:m.state];
			
			// Clear queues 
			nk_ar_queue_clear(remote->queue.cookie, cookieQueueLen);
			nk_ar_queue_clear(remote->queue.value, valueQueueLen);
		}
	}
}

static void nk_ar_secure_input_notification(void *refcon, io_service_t	service, uint32_t messageType, void *messageArgument) {
	NKAppleRemote *remote = (__bridge NKAppleRemote *)refcon;
	BOOL sin = [remote secureEventInputEnabled];
	if (sin != remote->flags.sin) {
		[remote closeDevice];
		[remote openDevice];
		remote->flags.sin = sin;
		NSLog(@"Info: regained access to remote control");
	}
}

- (BOOL)openDevice {
	// Check if device and interface have been properly initialized
	if (device != NULL) {
		NSLog(@"Error: remote device is already opened");
		return NO;
	}
	
	// Search for matching service
	io_service_t service = IOServiceGetMatchingService(kIOMasterPortDefault,
																										 IOServiceMatching(kNKAppleRemoteDeviceName));
	
	// Create the device
	device = IOHIDDeviceCreate(kCFAllocatorDefault, service);
	if (device == NULL) {
		NSLog(@"Error: could not access the remote device");
		return NO;
	}
	
	// Get device access mode
	IOHIDOptionsType accessMode = exclusive ? kIOHIDOptionsTypeSeizeDevice : kIOHIDOptionsTypeNone;
	
	// Open the device
	IOReturn result = IOHIDDeviceOpen(device, accessMode);
	if (result == kIOReturnExclusiveAccess) {
		NSLog(@"Another application has exclusive remote access, trying to open in passive mode ...");
		result =  IOHIDDeviceOpen(device, kIOHIDOptionsTypeNone);
	}
	
	if (result != kIOReturnSuccess) {
		device = NULL;
		NSLog(@"Error: could not access remote device");
		return NO;
	}
	
	// Register input callback and schedule device with runloop
	IOHIDDeviceRegisterInputValueCallback(device, nk_ar_hid_input_value_callback, (__bridge void *)self);
	IOHIDDeviceScheduleWithRunLoop(device, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
	
	return YES;
}

- (BOOL)closeDevice {
	// We can only close something if its opened ...
	if (device == NULL) {
		NSLog(@"Error: device not opened");
		return NO;
	}
	
	// Unschedule from runloop
	IOHIDDeviceUnscheduleFromRunLoop(device, CFRunLoopGetMain(), kCFRunLoopDefaultMode);
	
	// Close the device
	IOReturn status = IOHIDDeviceClose(device, kIOHIDOptionsTypeNone);
	if (status != kIOReturnSuccess) {
		NSLog(@"Error: could not close device");
	}
	
	device = NULL;
	
	return YES;
}

- (BOOL)secureEventInputEnabled {
	BOOL flag = NO;
	io_registry_entry_t root = IORegistryGetRootEntry(kIOMasterPortDefault);
	if (root) {
		NSArray *properties = (__bridge NSArray *)IORegistryEntrySearchCFProperty(root,
                                                                              kIOServicePlane,
                                                                              CFSTR("IOConsoleUsers"),
                                                                              kCFAllocatorDefault,
                                                                              kIORegistryIterateRecursively);
		for (int i=0; i<[properties count]; i++) {
			NSDictionary *info = [properties objectAtIndex:i];
			NSString *user = [info objectForKey:@"kCGSSessionUserNameKey"];
			if ([user isEqualToString:NSUserName()]) {
				flag = ([info objectForKey:@"kCGSSessionSecureInputPID"] != nil);
			}
		}
		
		IOObjectRelease(root);
	}
	
	return flag;
}

- (void)buttonEventPosted:(RKAppleRemoteButton)buttonId state:(RKAppleRemoteButtonState)state {
	@autoreleasepool {
    // Post raw key event
    if ([delegate respondsToSelector:@selector(remote:postedKey:state:)]) {
      [delegate remote:self postedKey:buttonId state:state];
    }
    
    // Post explicit events
    if (state == RKAppleRemoteButtonStateDown &&
        [delegate respondsToSelector:@selector(remote:buttonDown:)]) {
      [delegate remote:self buttonDown:buttonId];
    }
    if (state == RKAppleRemoteButtonStateUp &&
        [delegate respondsToSelector:@selector(remote:buttonUp:)]) {
      [delegate remote:self buttonUp:buttonId];
    }
    if (state == RKAppleRemoteButtonStateHoldDown &&
        [delegate respondsToSelector:@selector(remote:buttonHold:)]) {
      [delegate remote:self buttonHold:buttonId];
    }
    if (state == RKAppleRemoteButtonStateHoldUp &&
        [delegate respondsToSelector:@selector(remote:buttonHoldUp:)]) {
      [delegate remote:self buttonHoldUp:buttonId];
    }
  }
}

@end
