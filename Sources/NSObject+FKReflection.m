#import "NSObject+FKReflection.h"
#import "NSObject+FKAssociatedObjects.h"
#import "NSNumber+FKConcise.h"
#import <objc/runtime.h>

FKLoadCategory(NSObjectFKReflection);

static char objectTagKey;
static char metaDataKey;

@implementation NSObject (FKReflection)

+ (instancetype)fkit_castedObjectOrNil:(id)object {
  if ([object isKindOfClass:self]) {
    return object;
  }

  return nil;
}

- (void)fkit_setObjectTag:(NSInteger)objectTag {
  [self fkit_associateValue:@(objectTag) withKey:&objectTagKey];
}

- (NSInteger)fkit_objectTag {
  return [[self fkit_associatedValueForKey:&objectTagKey] integerValue];
}

- (void)fkit_setMetaData:(id)metaData {
  [self fkit_associateValue:metaData withKey:&metaDataKey];
}

- (id)fkit_metaData {
  return [self fkit_associatedValueForKey:&metaDataKey];
}

@end
