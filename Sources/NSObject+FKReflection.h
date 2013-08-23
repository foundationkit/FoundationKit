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
 
 UIButton *button = [UIButton fkit_castedObjectOrNil:someView];
 if (button != nil) {
     // someView was a button
 }
 */
+ (instancetype)fkit_castedObjectOrNil:(id)object;

/** used to give each object a tag, similar to the tag-property of UIView */
@property (nonatomic, assign, setter = fkit_setObjectTag:) NSInteger fkit_objectTag;
/** used to associate metaData of any type with an object */
@property (nonatomic, strong, setter = fkit_setMetaData:) id fkit_metaData;

@end
