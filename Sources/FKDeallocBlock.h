// Part of FoundationKit http://foundationk.it
//
// Derived by Tom Harrington's Blog-Post: http://www.cimgf.com/2012/02/17/extending-nsdata-and-not-overriding-dealloc/

#import <Foundation/Foundation.h>

typedef dispatch_block_t fk_dealloc_block_t;

/**
 This class serves as a wrapper around a block that can be executed upon deallocation of another object,
 when associating an instance of FKDeallocBlock with the other object.
 */
@interface FKDeallocBlock : NSObject

/** the block that gets executed in dealloc */
@property (nonatomic, copy) fk_dealloc_block_t block;

/**
 Creates an instance of FKDeallocBlock with the given block.
 This is the designated initializer.
 
 @param block the block to be executed in dealloc
 */
- (id)initWithBlock:(fk_dealloc_block_t)block;

@end
