#import "NSNotificationCenter+FKMainThread.h"
#import "FKDispatch.h"

@implementation NSNotificationCenter (FKMainThread)

- (void)fkit_postNotificationOnMainThread:(NSNotification *)notification {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self postNotification:notification];
  });
}

- (void)fkit_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self postNotificationName:name object:object];
  });
}

- (void)fkit_postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self postNotificationName:name object:object userInfo:userInfo];
  });
}

@end
