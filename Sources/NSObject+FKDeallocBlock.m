#import "NSObject+FKDeallocBlock.h"
#import "NSObject+FKAssociatedObjects.h"

static char deallocBlocksKey;

@implementation NSObject (FKDeallocBlock)

- (void)addDeallocBlock:(fk_dealloc_block_t)block {
  NSMutableArray *deallocBlocks = [self associatedValueForKey:&deallocBlocksKey];
  
  if (deallocBlocks == nil) {
    deallocBlocks = [NSMutableArray array];
    [self associateValue:deallocBlocks withKey:&deallocBlocksKey];
  }
  
  FKDeallocBlock *blockWrapper = [[FKDeallocBlock alloc] initWithBlock:block];
  [deallocBlocks addObject:blockWrapper];
}

@end
