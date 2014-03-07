#import "NSDictionary+FKBlocks.h"

FKLoadCategory(NSDictionaryFKBlocks);

@implementation NSDictionary (FKBlocks)

- (BOOL)fkit_all:(BOOL (^)(id object))block {
  for (id obj in self) {
    if (!block(obj)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)fkit_any:(BOOL (^)(id object))block {
  for (id obj in self) {
    if (block(obj)) {
      return YES;
    }
  }
  return NO;
}

- (NSDictionary *)fkit_filter:(BOOL (^)(id key, id object))block {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    if(block(key, obj)) {
      [result setObject:obj forKey:key];
    }
  }];
  return result;
}

- (NSDictionary *)fkit_map:(id (^)(id object))block {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    id mapped = block(obj) ?: [NSNull null];
    [result setObject:mapped forKey:key];
  }];
  return result;
}

@end