// Part of FoundationKit http://foundationk.it
//
// Originally created by Andy Matuschek in public domain, because he loves us:
// https://github.com/andymatuschak/NSObject-AssociatedObjects

#import "NSObject+FKAssociatedObjects.h"
#import <objc/runtime.h>

@implementation NSObject (FKAssociatedObjects)

- (void)associateValue:(id)value withKey:(void *)key {
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)associateWeakValue:(id)value withKey:(void *)key; {
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)associateCopiedValue:(id)value withKey:(void *)key {
  objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_COPY);
}

- (id)associatedValueForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

@end
