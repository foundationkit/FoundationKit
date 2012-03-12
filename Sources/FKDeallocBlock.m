#import "FKDeallocBlock.h"

@implementation FKDeallocBlock

@synthesize block = _block;

////////////////////////////////////////////////////////////////////////
#pragma mark - Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)initWithBlock:(fk_dealloc_block_t)block {
  if ((self = [super init])) {
    _block = [block copy];
  }
  
  return self;
}

- (void)dealloc {
  if (_block != nil) {
    _block();
  }
}

@end
