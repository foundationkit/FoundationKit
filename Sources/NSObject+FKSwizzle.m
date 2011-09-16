#import "NSObject+FKSwizzle.h"
#import <objc/objc-class.h>


@implementation NSObject (FKSwizzle)

static void NSObjectNKSwizzleSetError(NSError **error, NSInteger code, NSString *format, ...) {
  if (error) {
    va_list args;
    va_start(args, format);
    NSString *msg = [[NSString alloc] initWithFormat:format arguments:args];
    *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                 code:code
                             userInfo:[NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey]];
    va_end(args);
  }
}

+ (BOOL)swizzleMethod:(SEL)slcOrig withMethod:(SEL)slcAlt error:(NSError**)error {
	Method origMethod = class_getInstanceMethod(self, slcOrig);
	if (origMethod == NULL) {
    NSObjectNKSwizzleSetError(error,
                              0x100,
                              @"original method %@ not found for class %@",
                              NSStringFromSelector(slcOrig),
                              NSStringFromClass([self class]));
		return NO;
	}
  
	Method altMethod = class_getInstanceMethod(self, slcAlt);
	if (altMethod == NULL) {
		NSObjectNKSwizzleSetError(error,
                              0x101,
                              @"alternate method %@ not found for class %@",
                              NSStringFromSelector(slcAlt),
                              NSStringFromClass([self class]));
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
