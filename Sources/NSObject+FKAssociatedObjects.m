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

- (void)fkit_associateValue:(id)value withKey:(void *)key policy:(FKAssociationPolicy)policy {
  if (FKIsValidAssociationPolicy(policy)) {
    objc_setAssociatedObject(self, key, value, policy);
  } else {
    FKLogDebug(@"Policy %d is no valid association policy, can't associate value with object '%@'", (int)policy, self);
  }
}

- (void)fkit_associateValue:(id)value withKey:(void *)key {
  [self fkit_associateValue:value withKey:key policy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

- (void)fkit_associateWeakValue:(id)value withKey:(void *)key; {
  [self fkit_associateValue:value withKey:key policy:OBJC_ASSOCIATION_ASSIGN];
}

- (void)fkit_associateCopiedValue:(id)value withKey:(void *)key {
  [self fkit_associateValue:value withKey:key policy:OBJC_ASSOCIATION_COPY_NONATOMIC];
}

- (id)fkit_associatedValueForKey:(void *)key {
	return objc_getAssociatedObject(self, key);
}

- (BOOL)fkit_hasAssociatedValueForKey:(void *)key {
  return [self fkit_associatedValueForKey:key] != nil;
}

@end
