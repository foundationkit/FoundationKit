// Part of FoundationKit http://foundationk.it


@interface NSArray (FKBlocks)

- (BOOL)fkit_all:(BOOL (^)(id object))block;
- (BOOL)fkit_any:(BOOL (^)(id object))block;
- (NSArray *)fkit_filter:(BOOL (^)(id object))block;
- (NSArray *)fkit_map:(id (^)(id object))block;

@end