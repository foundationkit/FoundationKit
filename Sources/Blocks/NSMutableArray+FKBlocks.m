#import "NSMutableArray+FKBlocks.h"

FKLoadCategory(NSMutableArrayFKBlocks);

@implementation NSMutableArray (FKBlocks)

- (void)fkit_filterOnSelf:(BOOL (^)(id))block {
  NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
  NSUInteger index = 0;
  for (id obj in self) {
    if (!block(obj))  {
      [indexes addIndex:index];
    }
    index++;
  }
  [self removeObjectsAtIndexes:indexes];
}

- (void)fkit_mapOnSelf:(id (^)(id))block {
  NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
  NSMutableArray *objectsToReplace = [NSMutableArray array];
  NSUInteger index = 0;
  for (id obj in self) {
    id newObj = block(obj);
    if(newObj != obj && newObj != nil) {
      [indexes addIndex:index];
      [objectsToReplace addObject:newObj];
    }
    index++;
  }
  [self replaceObjectsAtIndexes:indexes withObjects:objectsToReplace];
}

@end