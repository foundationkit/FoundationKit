#import "NSDictionary+FKBlocks.h"

FKLoadCategory(NSDictionaryFKBlocks);

@implementation NSDictionary (FKBlocks)

- (BOOL)all:(BOOL (^)(id object))block {
  for (id obj in self) {
    if (!block(obj)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)any:(BOOL (^)(id object))block {
  for (id obj in self) {
    if (block(obj)) {
      return YES;
    }
  }
  return NO;
}

- (void)each:(void (^)(id key, id object))block {
  [self enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) { block(key, object); }];
}

- (void)eachWithStop:(void (^)(id key, id object, BOOL *stop))block {
  [self enumerateKeysAndObjectsUsingBlock:block];
}

- (NSDictionary *)select:(BOOL (^)(id key, id object))block {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self each:^ (id key, id object) {
    if(block(key, object)) {
      [result setObject:object forKey:key];
    }
  }];
  return result;
}

- (NSDictionary *)map:(id (^)(id object))block {
  NSMutableDictionary *result = [NSMutableDictionary dictionary];
  [self each:^ (id key, id object) {
    [result setObject:block(object) forKey:key];
  }];
  return result;
}

@end