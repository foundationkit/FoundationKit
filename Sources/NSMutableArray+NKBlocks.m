#import "NSMutableArray+NKBlocks.h"
#import "NSArray+NKBlocks.h"

@implementation NSMutableArray (NKBlocks)

- (void)selectOnSelf:(BOOL (^)(id))block {
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];

    NSUInteger index = 0;
    for (id obj in self) {
        if (!block(obj))
            [indexes addIndex:index];
        index++;
    }
    [self removeObjectsAtIndexes:indexes];
}

- (void)mapOnSelf:(id (^)(id))block {
    NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
    NSMutableArray *objectsToReplace = [NSMutableArray array];
    
    NSUInteger index = 0;
    for (id obj in self) {
        id newObj = block(obj);
        if(obj != newObj) {
            [indexes addIndex:index];
            [objectsToReplace addObject:newObj];
        }
        index++;
    }
    [self replaceObjectsAtIndexes:indexes withObjects:objectsToReplace];
}

@end
