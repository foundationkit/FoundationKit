// Part of FoundationKit http://foundationk.it


@interface NSMutableArray (FKBlocks)

- (void)selectOnSelf:(BOOL (^)(id))block;
- (void)mapOnSelf:(id (^)(id))block;

@end
