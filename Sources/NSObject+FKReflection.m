#import "NSObject+FKReflection.h"
#import "NSObject+FKAssociatedObjects.h"
#import "NSNumber+FKConcise.h"
#import <objc/runtime.h>

FKLoadCategory(NSObjectFKReflection);

static char objectTagKey;
static char metaDataKey;

@implementation NSObject (FKReflection)

- (void)setObjectTag:(NSInteger)objectTag {
  [self associateValue:$long(objectTag) withKey:&objectTagKey];
}

- (NSInteger)objectTag {
  return [[self associatedValueForKey:&objectTagKey] integerValue];
}

- (void)setMetaData:(id)metaData {
  [self associateValue:metaData withKey:&metaDataKey];
}
   
- (id)metaData {
  return [self associatedValueForKey:&metaDataKey];
}

- (NSArray *)methods {
  NSMutableArray *array = [NSMutableArray array];
	unsigned int count;
	Method *methods = class_copyMethodList([self class], &count);
  
	for (int i = 0; i < count; i++) {
		NSString *method = NSStringFromSelector(method_getName(methods[i]));
		[array addObject:method];
	}
  
	free(methods);
  
	return [array copy];
}

- (NSArray *)ivars {
  NSMutableArray *array = [NSMutableArray array];
	unsigned int count;
	Ivar *ivars = class_copyIvarList([self class], &count);
  
	for (int i = 0; i < count; i++) {
		NSString *iVar = [NSString stringWithCString:ivar_getName(ivars[i]) 
                                        encoding:NSUTF8StringEncoding];
		[array addObject:iVar];
	}
  
	free(ivars);
  
	return [array copy];
}

- (NSArray *)properties {
  NSMutableArray *array = [NSMutableArray array];
	unsigned int count;
  objc_property_t *properties = class_copyPropertyList([self class], &count);
  
	for (int i = 0; i < count; i++) {
		NSString *property = [NSString stringWithCString:property_getName(properties[i]) 
                                            encoding:NSUTF8StringEncoding];
		[array addObject:property];
	}
  
	free(properties);
  
	return [array copy];
}

@end
