#import "NSDictionary+NKBlocks.h"

@implementation NSDictionary (NKBlocks)

- (BOOL)all:(BOOL (^)(id, id))block {
    return YES;
}
- (BOOL)any:(BOOL (^)(id, id))block {
    return NO;
}

- (void)each:(void (^)(id key, id obj))block {
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) { block(key, obj); }];
}

- (void)eachWithStop:(void (^)(id key, id obj, BOOL *stop))block {
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (NSDictionary *)select:(BOOL (^)(id, id))block {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self each:^ (id key, id obj) {
        if(block(key, obj))
            [result setObject:obj forKey:key];
    }];
    return result;
}

- (NSDictionary *)map:(id (^)(id))block {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [self each:^ (id key, id obj) {
        [result setObject:block(obj) forKey:key];
    }];
    return result;
}

@end