// Part of FoundationKit http://foundationk.it

#import "NSMutableArray+FKConcise.h"

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

- (void)moveObjectAtIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex {
	if (oldIndex == newIndex) {
		return;
  }
  
	id item = [self objectAtIndex:oldIndex];
  
	if (newIndex == self.count) {
		[self addObject:item];
		[self removeObjectAtIndex:oldIndex];
	}
	else {
		[self removeObjectAtIndex:oldIndex];
		[self insertObject:item atIndex:newIndex];
	}
}

// http://en.wikipedia.org/wiki/Knuth_shuffle
- (void)shuffle {
  for(NSUInteger i = self.count; i > 1; i--) {
    NSUInteger j = FKRandomNumberBelow(i);
    
    [self exchangeObjectAtIndex:i-1 withObjectAtIndex:j];
  }
}

@end
