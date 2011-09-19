// Part of FoundationKit http://foundationk.it
//
// Derived from Gi-Lo's BSD-Licensed COKit: https://github.com/Gi-lo/COKit

#import <Foundation/Foundation.h>

@interface NSObject (FKReflection)

@property (nonatomic, assign) NSInteger objectTag;
@property (nonatomic, strong) id metaData;

@property (nonatomic, readonly) NSArray *methods;
@property (nonatomic, readonly) NSArray *ivars;
@property (nonatomic, readonly) NSArray *properties;

@end
