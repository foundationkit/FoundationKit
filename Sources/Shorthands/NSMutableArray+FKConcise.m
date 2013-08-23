// Part of FoundationKit http://foundationk.it

#import "NSMutableArray+FKConcise.h"

FKLoadCategory(NSMutableArrayFKConcise);

// Unbiased random rounding thingy.
static NSUInteger FKRandomNumberBelow(NSUInteger n) {
  NSUInteger m = 1;
	
  do {
    m <<= 1;
  } while(m < n);
	
  NSUInteger ret;
	
  do {
    ret = arc4random() % m;
  } while(ret >= n);
	
  return ret;
}

@implementation NSMutableArray (FKConcise)

// http://en.wikipedia.org/wiki/Knuth_shuffle
- (void)fkit_shuffle {
  for(NSUInteger i = self.count; i > 1; i--) {
    NSUInteger j = FKRandomNumberBelow(i);
    
    [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
  }
}

- (void)fkit_addObjectIfNotNil:(id)object {
  if (object != nil) {
    [self addObject:object];
  }
}

@end
