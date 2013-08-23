// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>
#import "FKDeallocBlock.h"

/**
 This category serves as a shorthand for adding a FKDeallocBlock to an object,
 which gets executed when the object gets destroyed.
 */
@interface NSObject (FKDeallocBlock)

- (void)fkit_addDeallocBlock:(fk_dealloc_block_t)block;

@end
