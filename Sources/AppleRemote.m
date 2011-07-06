//
//  AppleRemote.m
//  SweetFM 2
//
//  Created by Erik Aigner on 16.09.10.
//  Copyright 2010 chocomoko.com. All rights reserved.
//
//	SecureEventInput recovery code by Martin Kahr
//  http://www.martinkahr.com/Welcome.html
//

#import "AppleRemote.h"


#define NSSTR(str) (NSString *)CFSTR(str)

char * const kAppleRemoteDeviceName = "AppleIRController";

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
typedef struct match_t {
	int				id;
	int				state;
	uint32_t	cookieMatch[10];
	uint32_t	valueMatch[10];
} match_t;


// Remote button matching table
//
const match_t match_table[] = {
	{
		kRemoteButtonCenter,
		kRemoteButtonStateDown,
		kRemoteButtonCenter10_6_Alu,
		{1, 1}
	},
	{
		kRemoteButtonCenter,
		kRemoteButtonStateUp,
		kRemoteButtonCenter10_6_Alu,
		{0}
	},
	{
		kRemoteButtonCenter,
		kRemoteButtonStateHoldDown,
		kRemoteButtonCenter10_6_Alu_Hold,
		{9, 1}
	},
	{
		kRemoteButtonCenter,
		kRemoteButtonStateHoldUp,
		kRemoteButtonCenter10_6_Alu_Hold,
		{0}
	},
	{
		kRemoteButtonPlay,
		kRemoteButtonStateDown,
		kRemoteButtonPlay10_6,
		{6, 1}
	},
	{
		kRemoteButtonPlay,
		kRemoteButtonStateUp,
		kRemoteButtonPlay10_6,
		{0}
	},
	{
		kRemoteButtonPlay,
		kRemoteButtonStateHoldDown,
		kRemoteButtonPlay10_6_Hold,
		{0, 0, 0, 4, 1}
	},
	{
		kRemoteButtonPlay,
		kRemoteButtonStateHoldUp,
		kRemoteButtonPlay10_6_Hold,
		{0}
	},
	{
		kRemoteButtonPlay,
		kRemoteButtonStateDown,
		kRemoteButtonPlay10_6_Alu,
		{6, 1}
	},
	{
		kRemoteButtonPlay,
		kRemoteButtonStateUp,
		kRemoteButtonPlay10_6_Alu,
		{0}
	},
	{
		kRemoteButtonMenu,
		kRemoteButtonStateDown,
		kRemoteButtonMenu10_6,
		{0, 0, 1, 1}
	},
	{
		kRemoteButtonMenu,
		kRemoteButtonStateUp,
		kRemoteButtonMenu10_6,
		{0}
	},
	{
		kRemoteButtonMenu,
		kRemoteButtonStateHoldDown,
		kRemoteButtonMenu10_6_Hold,
		{0, 1}
	},
	{
		kRemoteButtonMenu,
		kRemoteButtonStateHoldUp,
		kRemoteButtonMenu10_6_Hold,
		{0}
	},
	{
		kRemoteButtonLeft,
		kRemoteButtonStateDown,
		kRemoteButtonLeft10_6,
		{0, 0, 4, 1}
	},
	{
		kRemoteButtonLeft,
		kRemoteButtonStateUp,
		kRemoteButtonLeft10_6,
		{0}
	},
	{
		kRemoteButtonLeft,
		kRemoteButtonStateHoldDown,
		kRemoteButtonLeft10_6_Hold,
		{0, 1, 1}
	},
	{
		kRemoteButtonLeft,
		kRemoteButtonStateHoldUp,
		kRemoteButtonLeft10_6_Hold,
		{0}
	},
	{
		kRemoteButtonRight,
		kRemoteButtonStateDown,
		kRemoteButtonRight10_6,
		{0, 0, 3, 1}
	},
	{
		kRemoteButtonRight,
		kRemoteButtonStateUp,
		kRemoteButtonRight10_6,
		{0}
	},
	{
		kRemoteButtonRight,
		kRemoteButtonStateHoldDown,
		kRemoteButtonRight10_6_Hold,
		{0, 2, 1}
	},
	{
		kRemoteButtonRight,
		kRemoteButtonStateHoldUp,
		kRemoteButtonRight10_6_Hold,
		{0}
	},
	{
		kRemoteButtonPlus,
		kRemoteButtonStateDown,
		kRemoteButtonPlus10_6,
		{0, 0, 0, 1, 1}
	},
	{
		kRemoteButtonPlus,
		kRemoteButtonStateUp,
		kRemoteButtonPlus10_6,
		{0}
	},
	{
		kRemoteButtonMinus,
		kRemoteButtonStateDown,
		kRemoteButtonMinus10_6,
		{0, 0, 0, 2, 1}
	},
	{
		kRemoteButtonMinus,
		kRemoteButtonStateUp,
		kRemoteButtonMinus10_6,
		{0}
	}
};

#define kMatchTableLen 26

void secureInputNotification(void *refcon, io_service_t	service, uint32_t messageType, void *messageArgument);

@interface AppleRemote ()

- (void)buttonEventPosted:(ARButton)buttonId state:(ARButtonState)state;

@end

@implementation AppleRemote
@synthesize delegate;
@synthesize exclusive;

+ (NSString *)nameForButton:(ARButton)aButton {
	switch (aButton) {
		case kRemoteButtonPlay: return @"Play";
		case kRemoteButtonCenter: return @"Center";
		case kRemoteButtonPlus: return @"Plus";
		case kRemoteButtonMinus: return @"Minus";
		case kRemoteButtonLeft: return @"Left";
		case kRemoteButtonRight: return @"Right";
		case kRemoteButtonMenu: return @"Menu";
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
																																&secureInputNotification,
																																self,
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
	[super dealloc];
}

void queuePut(uint32_t val, uint32_t *q, int qlen) {
	for (int i=qlen-1; i>0; i--) {
		q[i] = q[i-1];
	}
	q[0] = val;
}

void queueClear(uint32_t *q, int qlen) {
	for (int i=0; i<qlen; i++) {
		q[i] = 0;
	}
}

int queueLen(uint32_t q[]) {
	int i = 0;
	uint32_t val = 0;
	do {
		val = q[i];
		i++;
	} while (val > 0);
	
	return (i-1);
}

void hidInputValueCallback(void *context, IOReturn result, void *sender, IOHIDValueRef value) {
	AppleRemote *remote = (AppleRemote *)context;
	IOHIDElementRef element = IOHIDValueGetElement(value);
	IOHIDElementCookie cookie = IOHIDElementGetCookie(element);
	CFIndex intValue = IOHIDValueGetIntegerValue(value);
	
	// Put cookie in queue
	uint32_t cookieQueueLen = sizeof(remote->queue.cookie)/sizeof(uint32_t);
	uint32_t valueQueueLen = sizeof(remote->queue.value)/sizeof(uint32_t);
	
	queuePut((uint32_t)cookie, remote->queue.cookie, cookieQueueLen);
	queuePut((uint32_t)intValue, remote->queue.value, valueQueueLen);
	
	// Match button
	for (int i=0; i<kMatchTableLen; i++) {
		match_t m = match_table[i];
		
		int cnt = 0;
		int qlen = queueLen(m.cookieMatch);
		
		for (int n=0; n<qlen; n++) {
			cnt += (m.cookieMatch[n] == remote->queue.cookie[n]);
			cnt += (m.valueMatch[n] == remote->queue.value[n]);
		}
		
		int found = (cnt == qlen*2);		
		if (found) {
			// Dispatch event to delegate
			[remote buttonEventPosted:m.id state:m.state];
			
			// Clear queues 
			queueClear(remote->queue.cookie, cookieQueueLen);
			queueClear(remote->queue.value, valueQueueLen);
		}
	}
}

void secureInputNotification(void *refcon, io_service_t	service, uint32_t messageType, void *messageArgument) {
	AppleRemote *remote = (AppleRemote *)refcon;
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
																										 IOServiceMatching(kAppleRemoteDeviceName));
	
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
	IOHIDDeviceRegisterInputValueCallback(device, hidInputValueCallback, self);
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
		NSArray *properties = IORegistryEntrySearchCFProperty(root,
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

- (void)buttonEventPosted:(ARButton)buttonId state:(ARButtonState)state {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	
	// Post raw key event
	if ([delegate respondsToSelector:@selector(remote:postedKey:state:)]) {
		[delegate remote:self postedKey:buttonId state:state];
	}
	
	// Post explicit events
	if (state == kRemoteButtonStateDown &&
			[delegate respondsToSelector:@selector(remote:buttonDown:)]) {
		[delegate remote:self buttonDown:buttonId];
	}
	
	if (state == kRemoteButtonStateUp &&
			[delegate respondsToSelector:@selector(remote:buttonUp:)]) {
		[delegate remote:self buttonUp:buttonId];
	}
	
	if (state == kRemoteButtonStateHoldDown &&
			[delegate respondsToSelector:@selector(remote:buttonHold:)]) {
		[delegate remote:self buttonHold:buttonId];
	}
	
	if (state == kRemoteButtonStateHoldUp &&
			[delegate respondsToSelector:@selector(remote:buttonHoldUp:)]) {
		[delegate remote:self buttonHoldUp:buttonId];
	}

	[pool release];
}

@end
