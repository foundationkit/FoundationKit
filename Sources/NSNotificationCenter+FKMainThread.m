#import "NSNotificationCenter+FKMainThread.h"
#import "FKDispatch.h"

@implementation NSNotificationCenter (FKMainThread)

- (void)postNotificationOnMainThread:(NSNotification *)notification {
  dispatch_sync_on_main_queue(^{
    [self postNotification:notification];
  });
}

- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object {
  dispatch_sync_on_main_queue(^{
    [self postNotificationName:name object:object];
  });
}

- (void)postNotificationOnMainThreadWithName:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
  dispatch_sync_on_main_queue(^{
    [self postNotificationName:name object:object userInfo:userInfo];
  });
}

@end
