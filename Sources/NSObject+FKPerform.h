// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

@interface NSObject (FKPerform)

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay;

- (id)performSelectorIfResponding:(SEL)selector;
- (id)performSelectorIfResponding:(SEL)selector withObject:(id)object;
- (id)performSelectorIfResponding:(SEL)selector withObject:(id)object1 withObject:(id)object2;
@end
