// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

// do not block queue when called on same queue we want to dispatch to
void dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block);

// same as above, shortcut for main_queue
// CAUTION: If we believe the docs do not use this on iOS 4
void dispatch_sync_on_main_queue(dispatch_block_t block);