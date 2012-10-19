// Part of FoundationKit http://foundationk.it
//
// Derived from Gi-Lo's BSD-Licensed COKit: https://github.com/Gi-lo/COKit
// Derived from kballard's Gist: https://gist.github.com/3391903

#import <Foundation/Foundation.h>

/**
 This category adds various additions to NSObject that are useful for reflection.
 */
@interface NSObject (FKReflection)

/**
 Save cast to a given type, usage: 
 
 UIButton *button = [UIButton castedObjectOrNil:someView];
 if (button != nil) {
     // someView was a button
 }
 */
+ (instancetype)castedObjectOrNil:(id)object;

/** used to give each object a tag, similar to the tag-property of UIView */
@property (nonatomic, assign) NSInteger objectTag;
/** used to associate metaData of any type with an object */
@property (nonatomic, strong) id metaData;

/** List of all methods the object responds to */
@property (nonatomic, readonly) NSArray *methodNames;
/** List of all ivars of the object */
@property (nonatomic, readonly) NSArray *ivarNames;
/** List of all properties of the object */
@property (nonatomic, readonly) NSArray *propertyNames;

@end
