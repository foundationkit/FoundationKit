// Part of FoundationKit http://foundationk.it
//
// Derived from Erik Aigner's AppleRemote
// SecureEventInput recovery code by Martin Kahr http://www.martinkahr.com/Welcome.html

#import <Foundation/Foundation.h>

#import <IOKit/hid/IOHIDDevice.h>
#import <IOKit/hid/IOHIDElement.h>
#import <IOKit/hid/IOHIDValue.h>


typedef enum {
  RKAppleRemoteButtonPlay = 1,
  RKAppleRemoteButtonCenter,
  RKAppleRemoteButtonPlus,
  RKAppleRemoteButtonMinus,
  RKAppleRemoteButtonLeft,
  RKAppleRemoteButtonRight,
  RKAppleRemoteButtonMenu
} RKAppleRemoteButton;

typedef enum {
  RKAppleRemoteButtonStateUp = 1,
  RKAppleRemoteButtonStateDown,
  RKAppleRemoteButtonStateHoldDown,
  RKAppleRemoteButtonStateHoldUp
} RKAppleRemoteButtonState;

@protocol NKAppleRemoteDelegate;

@interface NKAppleRemote : NSObject {
@private
  IOHIDDeviceRef        device_;
  IONotificationPortRef sinPort_;
  io_object_t           sinNotification_;
  uint32_t              cookieQueue_[10];
  uint32_t              valueQueue_[10];
  BOOL                  secureInputEnabled_;
}

@property (nonatomic, weak) id<NSObject, NKAppleRemoteDelegate> delegate;
@property (nonatomic, weak) BOOL exclusive;

+ (NSString *)nameForButton:(RKAppleRemoteButton)button;

- (BOOL)openDevice;
- (BOOL)closeDevice;
- (BOOL)secureEventInputEnabled;

@end


@protocol NKAppleRemoteDelegate
@optional

- (void)remote:(NKAppleRemote *)aRemote postedKey:(RKAppleRemoteButton)keyCode state:(RKAppleRemoteButtonState)keyState;
- (void)remote:(NKAppleRemote *)aRemote buttonDown:(RKAppleRemoteButton)keyCode;
- (void)remote:(NKAppleRemote *)aRemote buttonUp:(RKAppleRemoteButton)keyCode;
- (void)remote:(NKAppleRemote *)aRemote buttonHold:(RKAppleRemoteButton)keyCode;
- (void)remote:(NKAppleRemote *)aRemote buttonHoldUp:(RKAppleRemoteButton)keyCode;

@end