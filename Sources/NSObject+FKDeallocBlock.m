#import "NSObject+FKDeallocBlock.h"
#import "NSObject+FKAssociatedObjects.h"

static char deallocBlocksKey;

@implementation NSObject (FKDeallocBlock)

- (void)fkit_addDeallocBlock:(fk_dealloc_block_t)block {
  NSMutableArray *deallocBlocks = [self fkit_associatedValueForKey:&deallocBlocksKey];
  
  if (deallocBlocks == nil) {
    deallocBlocks = [NSMutableArray array];
    [self fkit_associateValue:deallocBlocks withKey:&deallocBlocksKey];
  }
  
  FKDeallocBlock *blockWrapper = [[FKDeallocBlock alloc] initWithBlock:block];
  [deallocBlocks addObject:blockWrapper];
}

@end
