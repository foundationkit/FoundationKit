#import "NSMutableDictionary+FKBlocks.h"
#import "NSDictionary+FKBlocks.h"

FKLoadCategory(NSMutableDictionaryFKBlocks);

@implementation NSMutableDictionary (FKBlocks)

- (void)fkit_filterOnSelf:(BOOL (^)(id, id))block {
  NSMutableArray *keysToRemove = [NSMutableArray array];
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if(!block(key, obj)) {
      [keysToRemove addObject:key];
    }
  }];
  [self removeObjectsForKeys:keysToRemove];
}

// TODO: Test if mutation works while mapping
- (void)fkit_mapOnSelf:(id (^)(id))block {
  NSMutableDictionary *changedEntries = [NSMutableDictionary dictionary];
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    id newObj = block(obj) ?: [NSNull null];
    if(newObj != obj) {
      [changedEntries setObject:newObj forKey:key];
    }
  }];

  // This replaces already existing keys
  [self addEntriesFromDictionary:changedEntries];
}

@end