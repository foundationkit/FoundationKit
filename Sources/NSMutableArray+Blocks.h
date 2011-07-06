#import <Foundation/Foundation.h>

@interface NSMutableArray (Blocks)

- (void)selectOnSelf:(BOOL (^)(id))block;

- (void)mapOnSelf:(id (^)(id))block;

@end
