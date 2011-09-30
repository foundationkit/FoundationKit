// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>
#import "FKShorthands.h"

// do not block queue when called on same queue we want to dispatch to
// WARNING: do not use on main_queue
NS_INLINE void dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block) {
	if (dispatch_get_current_queue() == queue) {
		block();
	} else {
		dispatch_sync(queue, block);
	}
}

// NSThread isMainThread might be true on other queues than the main queue too
// but it works for the general case of "UI Update on main thread"
NS_INLINE void dispatch_sync_on_main_queue(dispatch_block_t block) {
  if ([NSThread isMainThread]) {
    block();
  } else {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}

/**
 This macro can be used to define a GCD-Queue that is guaranteed to be created only once.
 The identifier of the queue will be "com.AppName.AppVersion.QueueName"

 Usage:
 
 FKDefineGCDQueueWithName(foundation_queue);
 // ...
 dispatch_sync(foundation_queue(), ^{ NSLog(@"Logging on a queue."); });
 */

#define FKDefineGCDQueueWithName(QUEUE_NAME)                                    \
static dispatch_queue_t fk_##QUEUE_NAME;                                        \
dispatch_queue_t QUEUE_NAME(void);                                              \
dispatch_queue_t QUEUE_NAME(void) {                                             \
static dispatch_once_t onceToken;                                               \
dispatch_once(&onceToken, ^{                                                    \
NSString *queueIdentifier = [NSString stringWithFormat:@"com.%@.%@.%s",         \
FKApplicationName(), FKApplicationVersion(), #QUEUE_NAME];                      \
fk_##QUEUE_NAME = dispatch_queue_create([queueIdentifier UTF8String], 0);       \
});                                                                             \
return fk_##QUEUE_NAME;                                                         \
}