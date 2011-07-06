// Part of FoundationKit http://foundationk.it

@interface NSMutableDictionary (NKBlocks)

- (void)selectOnSelf:(BOOL (^)(id, id))block;

- (void)mapOnSelf:(id (^)(id))block;

@end
