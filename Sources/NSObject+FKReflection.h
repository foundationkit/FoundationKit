// Part of FoundationKit http://foundationk.it
//
// Derived from Gi-Lo's BSD-Licensed COKit: https://github.com/Gi-lo/COKit

#import <Foundation/Foundation.h>

/**
 This category adds various additions to NSObject that are useful for reflection.
 */
@interface NSObject (FKReflection)

/** used to give each object a tag, similar to the tag-property of UIView */
@property (nonatomic, assign) NSInteger objectTag;
/** used to associate metaData of any type with an object */
@property (nonatomic, strong) id metaData;

/** List of all methods the object responds to */
@property (nonatomic, readonly) NSArray *methods;
/** List of all ivars of the object */
@property (nonatomic, readonly) NSArray *ivars;
/** List of all properties of the object */
@property (nonatomic, readonly) NSArray *properties;

@end
