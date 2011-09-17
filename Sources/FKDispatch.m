#import "FKDispatch.h"


void dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block) {
	if (dispatch_get_current_queue() == queue) {
		block();
	} else {
		dispatch_sync(queue, block);
	}
}

void dispatch_sync_on_main_queue(dispatch_block_t block) {
  dispatch_sync_reentrant(dispatch_get_main_queue(), block);
}