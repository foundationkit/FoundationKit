// Part of FoundationKit http://foundationk.it
//
// Originally created by Andy Matuschek in public domain, because he loves us:
// https://github.com/andymatuschak/NSObject-AssociatedObjects

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/** Defines a meaningful name for association policies, since they are defined as anonymous enum */
typedef NSUInteger FKAssociationPolicy;
 
/** Defines equivalent names in FK-namespace for known association policies */
enum {
  FKAssociationPolicyAssign           = OBJC_ASSOCIATION_ASSIGN,
  FKAssociationPolicyRetainNonatomic  = OBJC_ASSOCIATION_RETAIN_NONATOMIC,
  FKAssociationPolicyCopyNonatomic    = OBJC_ASSOCIATION_COPY_NONATOMIC,
  FKAssociationPolicyRetain           = OBJC_ASSOCIATION_RETAIN,
  FKAssociationPolicyCopy             = OBJC_ASSOCIATION_COPY
};

/**
 This category adds concise Objective-C methods to NSObject for dealing with associated objects.
 */
@interface NSObject (FKAssociatedObjects)

/**
 Associates a value with the given key and policy with the object self.
 
 @param value the value that gets associated with self
 @param key the key that is used to identify the association. best to the address of a static char.
 @param policy the policy used for association. @see FKAssociationPolicy.
 */
- (void)fkit_associateValue:(id)value withKey:(void *)key policy:(FKAssociationPolicy)policy;

/**
 Associates a value with the given key and the policy OBJC_ASSOCIATION_RETAIN with the object self.
 
 @param value the value that gets associated with self
 @param key the key that is used to identify the association.
 */
- (void)fkit_associateValue:(id)value withKey:(void *)key;

/**
 Associates a value with the given key and the policy OBJC_ASSOCIATION_ASSIGN with the object self.
 
 @param value the value that gets associated with self
 @param key the key that is used to identify the association.
 */
- (void)fkit_associateWeakValue:(id)value withKey:(void *)key;

/**
 Associates a value with the given key and the policy OBJC_ASSOCIATION_COPY with the object self.
 
 @param value the value that gets associated with self
 @param key the key that is used to identify the association.
 */
- (void)fkit_associateCopiedValue:(id)value withKey:(void *)key;

/**
 Returns the value of the object associated with self under the given key.
 
 @param key the key used to identify the association
 @return the object associated with self and the given key
 */
- (id)fkit_associatedValueForKey:(void *)key;

/**
 Returns YES, if there is an object associated with self under the given key.
 
 @param key the key used to identify the association
 @return YES, if there is an object associated, NO otherwise
 */
- (BOOL)fkit_hasAssociatedValueForKey:(void *)key;

@end
