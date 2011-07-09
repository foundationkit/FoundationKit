// Part of FoundationKit http://foundationk.it


@interface NSMutableArray (NKBlocks)

- (void)selectOnSelf:(BOOL (^)(id))block;
- (void)mapOnSelf:(id (^)(id))block;

@end
