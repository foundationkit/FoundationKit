//
//  AppleRemote.h
//  SweetFM 2
//
//  Created by Erik Aigner on 16.09.10.
//  Copyright 2010 chocomoko.com. All rights reserved.
//
//	SecureEventInput recovery code by Martin Kahr
//  http://www.martinkahr.com/Welcome.html
//

#import <Cocoa/Cocoa.h>

#import <IOKit/hid/IOHIDDevice.h>
#import <IOKit/hid/IOHIDElement.h>
#import <IOKit/hid/IOHIDValue.h>


typedef enum {
	kRemoteButtonPlay = 1,
	kRemoteButtonCenter,
	kRemoteButtonPlus,
	kRemoteButtonMinus,
	kRemoteButtonLeft,
	kRemoteButtonRight,
	kRemoteButtonMenu
} ARButton;

typedef enum {
	kRemoteButtonStateUp = 1,
	kRemoteButtonStateDown,
	kRemoteButtonStateHoldDown,
	kRemoteButtonStateHoldUp
} ARButtonState;

@protocol RemoteDelegate;

@interface AppleRemote : NSObject {
	id										delegate;
	BOOL									exclusive;
	IOHIDDeviceRef				device;
	IONotificationPortRef	sinPort;
	io_object_t						sinNotification;
	
	struct {
		uint32_t cookie[10];
		uint32_t value[10];
	} queue;
	
	struct {
		BOOL sin;
	} flags;
}

@property (assign) id delegate;
@property (assign) BOOL exclusive;

+ (NSString *)nameForButton:(ARButton)aButton;

- (BOOL)openDevice;
- (BOOL)closeDevice;
- (BOOL)secureEventInputEnabled;

@end


@protocol RemoteDelegate
@optional

- (void)remote:(AppleRemote *)aRemote postedKey:(ARButton)keyCode state:(ARButtonState)keyState;
- (void)remote:(AppleRemote *)aRemote buttonDown:(ARButton)keyCode;
- (void)remote:(AppleRemote *)aRemote buttonUp:(ARButton)keyCode;
- (void)remote:(AppleRemote *)aRemote buttonHold:(ARButton)keyCode;
- (void)remote:(AppleRemote *)aRemote buttonHoldUp:(ARButton)keyCode;

@end