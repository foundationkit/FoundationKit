// Part of FoundationKit http://foundationk.it
//
// Originally created by Andy Matuschek in public domain, because he loves us:
// https://github.com/andymatuschak/NSObject-AssociatedObjects

#import <Foundation/Foundation.h>

@interface NSObject (FKAssociatedObjects)

- (void)associateValue:(id)value withKey:(void *)key;
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;

@end
