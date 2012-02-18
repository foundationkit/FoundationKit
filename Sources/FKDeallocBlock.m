#import "FKDeallocBlock.h"

@implementation FKDeallocBlock

@synthesize block = block_;

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithBlock:(fk_dealloc_block_t)block {
  if ((self = [super init])) {
    block_ = [block copy];
  }
  
  return self;
}

- (void)dealloc {
  if (block_ != nil) {
    block_();
  }
}

@end
