// Part of FoundationKit http://foundationk.it
//
// IsEmpty taken from http://www.wilshipley.com/blog/2005/10/pimp-my-code-interlude-free-code.html


#import <Foundation/Foundation.h>

// Shorthand for NSLocalizedString
NS_INLINE NSString* _(NSString *key) {
  return NSLocalizedString(key, nil);
}

NS_INLINE NSString* NKAppVersion() {
  return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
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

#if DEBUG
#define NKProperty(propertyName)	NSStringFromSelector(@selector(propertyName))
#else
#define NKProperty(propertyName)	@#propertyName
#endif


// Four char codes
NS_INLINE char * NKFcc(code) { return (char[5]){(code >> 24) & 0xFF, (code >> 16) & 0xFF, (code >> 8) & 0xFF, code & 0xFF, 0}; }

// Foundation functions for CF
NS_INLINE CFIndex CFMaxRange(CFRange range) { return (range.location + range.length); }
NS_INLINE Boolean CFLocationInRange(CFIndex location, CFRange range) { return (location >= range.location ? (location <= CFMaxRange(range) ? YES : NO) : NO); }


NS_INLINE BOOL NKIsEmpty(id object) {
	return object == nil || ([object isEqual:[NSNull null]]) ||
  ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0) ||
  ([object respondsToSelector:@selector(count)]  && [(NSArray *)object count] == 0);
}