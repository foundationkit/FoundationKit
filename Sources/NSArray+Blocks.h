#import <Foundation/Foundation.h>

@interface NSArray (Blocks)

- (BOOL)all:(BOOL (^)(id))block;
- (BOOL)any:(BOOL (^)(id))block;

- (void)each:(void (^)(id))block;
- (void)eachWithIndex:(void (^)(NSUInteger, id))block;

- (NSArray *)select:(BOOL (^)(id))block;

- (NSArray *)map:(id (^)(id))block;

- (id)collect:(id)initial withBlock:(id (^)(id,id))block;

@end
