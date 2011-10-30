// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/**
 This category add methods to NSNotificationCenter for posting Notifications on the main thread.
 */
@interface NSNotificationCenter (FKMainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification;
- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object;
- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

@end
