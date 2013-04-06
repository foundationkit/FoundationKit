// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>
#import "FKShorthands.h"


/**
 This macro can be used to define a GCD-Queue that is guaranteed to be created only once.
 The identifier of the queue will be "com.AppName.AppVersion.QueueName"

 Usage:

 FKDefineGCDQueueWithName(foundation_queue);
 // ...
 dispatch_sync(foundation_queue(), ^{ NSLog(@"Logging on a queue."); });
 */

#define FKDefineGCDQueueWithName(QUEUE_NAME)                                                  \
static dispatch_queue_t fk_##QUEUE_NAME;                                                      \
NS_INLINE dispatch_queue_t QUEUE_NAME(void) {                                                 \
  static dispatch_once_t onceToken;                                                           \
  dispatch_once(&onceToken, ^{                                                                \
    NSString *queueIdentifier = [NSString stringWithFormat:@"com.%@.%@.%s",                   \
     FKApplicationName(), FKApplicationVersion(), #QUEUE_NAME];   \
    fk_##QUEUE_NAME = dispatch_queue_create([queueIdentifier UTF8String], 0);                 \
  });                                                                                         \
  return fk_##QUEUE_NAME;                                                                     \
}


NS_INLINE void fk_dispatch_after(NSTimeInterval delayInSeconds, dispatch_block_t block) {
  if (block != nil) {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
  }
}
