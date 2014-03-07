// Part of FoundationKit http://foundationk.it


@interface NSMutableDictionary (FKBlocks)

- (void)fkit_filterOnSelf:(BOOL (^)(id, id))block;
- (void)fkit_mapOnSelf:(id (^)(id))block;

@end