// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

/**
 This category adds a block-delegate to NSOperationQueue that gets executed
 when the operationQueue finishes.
 */
@interface NSOperationQueue (FKBlocks)

/**
 This methods adds a block-delegate to the operationQueue that gets executed, when the queue finishes.
 
 @param block the block to execute, when he queue finishes
 */
- (void)fkit_whenFinished:(void (^)())block;

/**
 This method removes the block-delegate that gets executed, when the queue finishes.
 
 @see whenFinished
 */
- (void)fkit_removeFinishedBlock;

@end
