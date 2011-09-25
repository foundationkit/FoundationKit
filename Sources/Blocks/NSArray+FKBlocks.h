// Part of FoundationKit http://foundationk.it


@interface NSArray (FKBlocks)

- (BOOL)all:(BOOL (^)(id object))block;
- (BOOL)any:(BOOL (^)(id object))block;
- (void)each:(void (^)(id object))block;
- (void)eachWithIndex:(void (^)(NSUInteger index, id object))block;
- (NSArray *)select:(BOOL (^)(id object))block;
- (NSArray *)map:(id (^)(id object))block;
- (id)inject:(id)initial withBlock:(id (^)(id memo, id object))block;

@end
