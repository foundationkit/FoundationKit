#import <Foundation/Foundation.h>

@interface NSDictionary (Blocks)

- (BOOL)all:(BOOL (^)(id, id))block;
- (BOOL)any:(BOOL (^)(id, id))block;

- (void)each:(void (^)(id key, id obj))block;
- (void)eachWithStop:(void (^)(id key, id obj, BOOL *stop))block;

- (NSDictionary *)select:(BOOL (^)(id, id))block;

- (NSDictionary *)map:(id (^)(id))block;

@end
