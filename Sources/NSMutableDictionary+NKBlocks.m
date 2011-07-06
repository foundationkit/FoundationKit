#import "NSMutableDictionary+NKBlocks.h"
#import "NSDictionary+NKBlocks.h"

@implementation NSMutableDictionary (NKBlocks)

- (void)selectOnSelf:(BOOL (^)(id, id))block {
    NSMutableArray *keysToRemove = [NSMutableArray array];
    [self each:^ (id key, id obj) {
        if(!block(key, obj))
            [keysToRemove addObject:key];
    }];
    [self removeObjectsForKeys:keysToRemove];
}

// TODO: Test if mutation works while mapping
- (void)mapOnSelf:(id (^)(id))block {
    NSMutableDictionary *changedEntries = [NSMutableDictionary dictionary];
    
    [self each:^ (id key, id obj) {
        id newObj = block(obj);
        if(obj != newObj)
            [changedEntries setObject:newObj forKey:key];
    }];
    
    // This replaces already existing keys
    [self addEntriesFromDictionary:changedEntries];
}

@end
