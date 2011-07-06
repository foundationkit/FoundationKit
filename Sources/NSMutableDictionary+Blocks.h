#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Blocks)

- (void)selectOnSelf:(BOOL (^)(id, id))block;

- (void)mapOnSelf:(id (^)(id))block;

@end
