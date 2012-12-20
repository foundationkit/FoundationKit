// Part of FoundationKit http://foundationk.it


@interface NSDictionary (FKBlocks)

- (BOOL)all:(BOOL (^)(id object))block;
- (BOOL)any:(BOOL (^)(id object))block;
- (void)each:(void (^)(id key, id object))block;
- (void)eachWithStop:(void (^)(id key, id object, BOOL *stop))block;
- (NSDictionary *)select:(BOOL (^)(id key, id object))block;
- (NSDictionary *)map:(id (^)(id object))block;

@end
