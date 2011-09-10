// Part of FoundationKit http://foundationk.it

#import "NSObject+FKConcise.h"

@implementation NSObject (FKConcise)

- (void)performSelector:(SEL)selector afterDelay:(NSTimeInterval)delay {
	[self performSelector:selector withObject:nil afterDelay: delay];
}

@end
