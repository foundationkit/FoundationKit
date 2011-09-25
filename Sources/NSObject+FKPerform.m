// Part of FoundationKit http://foundationk.it

#import "NSObject+FKPerform.h"

@implementation NSObject (FKPerform)

// Silence clang warning that unknown performSelector can cause a leak (ARC)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay {
	[self performSelector:selector withObject:nil afterDelay: delay];
}

- (id)performSelectorIfResponding:(SEL)selector {
	if (![self respondsToSelector:selector]) {
    return nil;
  }
  
	return [self performSelector:selector];	
}

- (id)performSelectorIfResponding:(SEL)selector withObject:(id)object {
	if (![self respondsToSelector:selector]) {
    return nil;
  }
  
	return [self performSelector:selector withObject:object];	
}

- (id)performSelectorIfResponding:(SEL)selector withObject:(id)object1 withObject:(id)object2 {
	if (![self respondsToSelector:selector]) {
    return nil;
  }
  
	return [self performSelector:selector withObject:object1 withObject:object2];	
}

#pragma clang diagnostic pop

@end
