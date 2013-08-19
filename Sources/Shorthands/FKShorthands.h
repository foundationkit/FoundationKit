// Part of FoundationKit http://foundationk.it
//
// $empty derived from http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html


#import <Foundation/Foundation.h>

// Shorthand for NSLocalizedString
NS_INLINE NSString* _(NSString *key) {
  return NSLocalizedString(key, key);
}

NS_INLINE NSString* FKApplicationShortVersion() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

NS_INLINE NSString* FKApplicationVersion() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

NS_INLINE NSString* FKApplicationVersionFormatted() {
  return [NSString stringWithFormat:@"%@ (%@)", FKApplicationShortVersion(), FKApplicationVersion()];
}

NS_INLINE NSString* FKApplicationName() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

// runtime-check if class is available to make code more readable
NS_INLINE BOOL FKClassExists(NSString *className) {
  return NSClassFromString(className) != nil;
}

//	The following macro is for specifying property (ivar) names to KVC or KVO methods.
//	These methods generally take strings, but strings don't get checked for typos
//	by the compiler. If you write PROPERTY(fremen) instead of PROPERTY(frame),
//	the compiler will immediately complain that it doesn't know the selector
//	'fremen', and thus point out the typo. For this to work, you need to make
//	sure the warning -Wunknown-selector is on.
//
//	The code that checks here is (theoretically) slower than just using a string
//	literal, so what we do is we only do the checking in debug builds. In
//	release builds, we use the identifier-stringification-operator "#" to turn
//	the given property name into an ObjC string literal.

#ifdef FK_DEBUG
#define $property(propertyName)	NSStringFromSelector(@selector(propertyName))
#else
#define $property(propertyName)	@#propertyName
#endif

// Macro for compile-time errors of forbidden initializers, based on Javi Soto's Gist: https://gist.github.com/JaviSoto/5906004
#define FKDesignatedInitializer(__SEL__) __attribute__((unavailable("Invoke the designated initializer `" # __SEL__ "` instead.")))

// Shortcut for checking a bit in a bitmask
#define $flagSet(MASK, FLAG)  ((MASK & FLAG) == FLAG)

// macro to create a string-representation of a name (e.g. enum value)
#define $stringify(x) @"" #x ""

// Four char codes
#define FKFcc(code)  ((char[5]){(code >> 24) & 0xFF, (code >> 16) & 0xFF, (code >> 8) & 0xFF, code & 0xFF, 0})

// Foundation functions for CF
NS_INLINE CFIndex CFMaxRange(CFRange range) { return (range.location + range.length); }
NS_INLINE Boolean CFLocationInRange(CFIndex location, CFRange range) { return (location >= range.location ? (location <= CFMaxRange(range) ? YES : NO) : NO); }


NS_INLINE BOOL $empty(id object) {
	return object == nil || ([object isEqual:[NSNull null]]) ||
  ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) ||
  ([object respondsToSelector:@selector(count)]  && [(NSArray *)object count] == 0);
}

NS_INLINE BOOL $equals(id obj1, id obj2) {
	return (obj1 == obj2 || [obj1 isEqual:obj2]);
}
