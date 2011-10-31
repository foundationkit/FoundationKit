// Part of FoundationKit http://foundationk.it

#import "NSObject+FKDescription.h"
#import "NSObject+FKReflection.h"
#import <objc/runtime.h>

FKLoadCategory(NSObjectFKDescription);

@implementation NSObject (FKDescription)

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString *)autogeneratedDescriptionOf:(id)instance classType:(Class)classType {
  NSMutableArray *propertyArray = [NSMutableArray array];
  NSMutableString *description = [NSMutableString string];
	unsigned int count;
  objc_property_t *properties = class_copyPropertyList([self class], &count);
  
	for (int i = 0; i < count; i++) {
		NSString *property = [NSString stringWithCString:property_getName(properties[i]) 
                                            encoding:NSUTF8StringEncoding];
		[propertyArray addObject:property];
	}
  
	free(properties);
  
  for (NSString *propertyName in propertyArray) {
    if (propertyName != nil) {
      id value = [instance valueForKey:propertyName];
      
      // break describe cycle
      if (NSClassFromString(@"NSManagedObject") && [value isKindOfClass:NSClassFromString(@"NSManagedObject")]) {
        [description appendString:[NSString stringWithFormat:@"%@=%@ ; ", propertyName, NSStringFromClass([value class])]];
      } else {
        [description appendString:[NSString stringWithFormat:@"%@=%@ ; ", propertyName, [value description]]];
      }
    }
  }
  
  // Now see if we need to map any superclasses as well.
  /*Class superClass = class_getSuperclass( classType );
  
  if (superClass != nil && ![superClass isEqual:[NSObject class]]) {
    NSString *superString = [self autogeneratedDescriptionOf:instance classType:superClass];
    [propPrint appendString:superString];
  }*/
  
  return description;
}

+ (NSString *)autogeneratedDescriptionOf:(id)instance {
  NSString *headerString = [NSString stringWithFormat:@"%@:%p:: ",[instance class], instance];
  return [headerString stringByAppendingString:[self autogeneratedDescriptionOf:instance classType:[instance class]]];
}

@end
