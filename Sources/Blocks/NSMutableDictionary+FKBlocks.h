// Part of FoundationKit http://foundationk.it


@interface NSMutableDictionary (FKBlocks)

- (void)selectOnSelf:(BOOL (^)(id, id))block;
- (void)mapOnSelf:(id (^)(id))block;

@end
