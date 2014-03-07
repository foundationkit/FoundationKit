// Part of FoundationKit http://foundationk.it


@interface NSDictionary (FKBlocks)

- (BOOL)fkit_all:(BOOL (^)(id object))block;
- (BOOL)fkit_any:(BOOL (^)(id object))block;

- (NSDictionary *)fkit_filter:(BOOL (^)(id key, id object))block;
- (NSDictionary *)fkit_map:(id (^)(id object))block;

@end