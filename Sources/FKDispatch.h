// Part of FOundationKit http://foundationk.it

#import <Foundation/Foundation.h>

// do not block queue when called on same queue we want to dispatch to
NS_INLINE void dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block);

// same as above, shortcut for main_queue
NS_INLINE void dispatch_sync_on_main_queue(dispatch_block_t block);