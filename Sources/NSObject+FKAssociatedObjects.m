// Part of FoundationKit http://foundationk.it
//
// Originally created by Andy Matuschek in public domain, because he loves us:
// https://github.com/andymatuschak/NSObject-AssociatedObjects

#import "NSObject+FKAssociatedObjects.h"

FKLoadCategory(NSObjectFKAssociatedObjects);

NS_INLINE BOOL FKIsValidAssociationPolicy(FKAssociationPolicy policy) {
  switch (policy) {
    case FKAssociationPolicyAssign:
    case FKAssociationPolicyRetainNonatomic:
    case FKAssociationPolicyCopyNonatomic:
    case FKAssociationPolicyRetain:
    case FKAssociationPolicyCopy:
      return YES;
      
    default:
      return NO;
  }
}

@implementation NSObject (FKAssociatedObjects)

- (void)associateValue:(id)value withKey:(void *)key policy:(FKAssociationPolicy)policy {
  if (FKIsValidAssociationPolicy(policy)) {
    objc_setAssociatedObject(self, key, value, policy);
  } else {
    FKLogDebug(@"Policy %d is no valid association policy, can't associate value with object '%@'", (int)policy, self);
  }
}

- (void)associateValue:(id)value withKey:(void *)key {
  [self associateValue:value withKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)associateWeakValue:(id)value withKey:(void *)key; {
  [self associateValue:value withKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}

- (void)associateCopiedValue:(id)value withKey:(void *)key {
  [self associateValue:value withKey:key policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (id)associatedValueForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

- (BOOL)hasAssociatedValueForKey:(void *)key {
  return [self associatedValueForKey:key] != nil;
}

@end
