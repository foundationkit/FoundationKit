#import "NSObject+NKSwizzle.h"

#import <objc/objc-class.h>


@implementation NSObject (NKSwizzle)

#define SetNSErrorFor(FUNC, ERROR_VAR, CODE, FORMAT, ...)	\
  if (ERROR_VAR) {	\
    NSString *errStr = [NSString stringWithFormat:@"%s: " FORMAT, FUNC, ##__VA_ARGS__]; \
    *ERROR_VAR = [NSError errorWithDomain:NSCocoaErrorDomain \
                                     code:CODE	\
                                 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}
#define SetNSError(ERROR_VAR, CODE, FORMAT,...) SetNSErrorFor(__func__, ERROR_VAR, CODE, FORMAT, ##__VA_ARGS__)

+ (BOOL)swizzleMethod:(SEL)slcOrig withMethod:(SEL)slcAlt error:(NSError**)error {
	Method origMethod = class_getInstanceMethod(self, slcOrig);
	if (!origMethod) {
		SetNSError(error, 0x100, @"original method %@ not found for class %@", NSStringFromSelector(slcOrig), [self className]);
		return NO;
	}
  
	Method altMethod = class_getInstanceMethod(self, slcAlt);
	if (!altMethod) {
		SetNSError(error, 0x101, @"alternate method %@ not found for class %@", NSStringFromSelector(slcAlt), [self className]);
		return NO;
	}
  
	class_addMethod(self, slcOrig, class_getMethodImplementation(self, slcOrig), method_getTypeEncoding(origMethod));
	class_addMethod(self, slcAlt, class_getMethodImplementation(self, slcAlt), method_getTypeEncoding(altMethod));
	method_exchangeImplementations(class_getInstanceMethod(self, slcOrig), class_getInstanceMethod(self, slcAlt));
  
	return YES;
}

+ (BOOL)swizzleClassMethod:(SEL)slcOrig withClassMethod:(SEL)slcAlt error:(NSError**)error {
	return [[self class] swizzleMethod:slcOrig withMethod:slcAlt error:error];
}

@end
