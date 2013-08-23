// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/**
 This category add methods to NSNotificationCenter for posting Notifications on the main thread.
 */
@interface NSNotificationCenter (FKMainThread)

- (void)fkit_postNotificationOnMainThread:(NSNotification *)notification;
- (void)fkit_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object;
- (void)fkit_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

@end
