// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

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