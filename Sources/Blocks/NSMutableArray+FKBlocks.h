// Part of FoundationKit http://foundationk.it


@interface NSMutableArray (FKBlocks)

- (void)fkit_filterOnSelf:(BOOL (^)(id))block;
- (void)fkit_mapOnSelf:(id (^)(id))block;

@end