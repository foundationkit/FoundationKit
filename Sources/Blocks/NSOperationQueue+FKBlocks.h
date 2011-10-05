// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/** Type of the block that is executed, when the NSOperationQueue finished */
typedef void(^fk_queue_finished_block)();

/**
 This category adds a block-delegate to NSOperationQueue that gets executed
 when the operationQueue finishes.
 */
@interface NSOperationQueue (FKBlocks)

/**
 This methods adds a block-delegate to the operationQueue that gets executed, when the queue finishes.
 
 @param block the block to execute, when he queue finishes
 */
- (void)whenFinished:(void (^)())block;

/**
 This method removes the block-delegate that gets executed, when the queue finishes.
 
 @see whenFinished
 */
- (void)removeFinishedBlock;

@end
