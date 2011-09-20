// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

// do not block queue when called on same queue we want to dispatch to
// WARNING: do not use on main_queue
void dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block);