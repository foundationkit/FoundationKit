// Part of FoundationKit http://foundationk.it

#import "NSObject+FKPerform.h"

FKLoadCategory(NSObjectFKPerform);

@implementation NSObject (FKPerform)

// Silence clang warning that unknown performSelector can cause a leak (ARC)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)fkit_performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay {
	[self performSelector:selector withObject:nil afterDelay:delay];
}

- (void)fkit_performSelectorInNextRunLoop:(SEL)selector {
  [self performSelector:selector withObject:nil afterDelay:0];
}

- (void)fkit_performSelectorInNextRunLoop:(SEL)selector withObject:(id)object {
  [self performSelector:selector withObject:object afterDelay:0];
}

- (id)fkit_performSelectorIfResponding:(SEL)selector {
	if (![self respondsToSelector:selector]) {
    return nil;
  }
  
	return [self performSelector:selector];	
}

- (id)fkit_performSelectorIfResponding:(SEL)selector withObject:(id)object {
	if (![self respondsToSelector:selector]) {
    return nil;
  }
  
	return [self performSelector:selector withObject:object];	
}

- (id)fkit_performSelectorIfResponding:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
	if (![self respondsToSelector:selector]) {
    return nil;
  }
  
	return [self performSelector:selector withObject:object1 withObject:object2];	
}

#pragma clang diagnostic pop

@end
