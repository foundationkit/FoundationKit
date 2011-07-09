// Part of FoundationKit http://foundationk.it
//
// Derived from Jonathan Rentzsch's MIT-licensed JRSwizzle: https://github.com/rentzsch/jrswizzle


@interface NSObject (NKSwizzle)

+ (BOOL)swizzleMethod:(SEL)origSel withMethod:(SEL)altSel error:(NSError**)error;
+ (BOOL)swizzleClassMethod:(SEL)slcOrig withClassMethod:(SEL)slcAlt error:(NSError**)error;

@end
