#import "NSMutableArray+FKReorder.h"

@implementation NSMutableArray (FKReorder)

- (void)fkit_moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
  if (fromIndex != toIndex) {
    id object = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    
    if (toIndex >= self.count) {
      [self addObject:object];
    } else {
      [self insertObject:object atIndex:toIndex];
    }
  }
}

@end
