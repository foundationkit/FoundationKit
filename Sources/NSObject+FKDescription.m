// Part of FoundationKit http://foundationk.it

#import "NSObject+FKDescription.h"
#import <objc/runtime.h>

FKLoadCategory(NSObjectFKDescription);

@implementation NSObject (FKDescription)

// Finds all properties of an object, and prints each one out as part of a string describing the class.
+ (NSString *)autogeneratedDescriptionOf:(id)instance classType:(Class)classType {
  unsigned int count = 0;
  objc_property_t *propList = class_copyPropertyList(classType, &count);
  NSMutableString *propPrint = [NSMutableString string];
  
  for (int i = 0; i < count; i++) {
    objc_property_t property = propList[i];
    const char *propName = property_getName(property);
    NSString *propNameString =[NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
    
    if (propName != nil) {
      id value = [instance valueForKey:propNameString];
      
      // break describe cycle
      if (NSClassFromString(@"NSManagedObject") && [value isKindOfClass:NSClassFromString(@"NSManagedObject")]) {
        [propPrint appendString:[NSString stringWithFormat:@"%@=%@ ; ", propNameString, [value class]]];
      } else {
        [propPrint appendString:[NSString stringWithFormat:@"%@=%@ ; ", propNameString, value]];
      }
    }
  }
  
  free(propList);
  
  // Now see if we need to map any superclasses as well.
  Class superClass = class_getSuperclass( classType );
  
  if (superClass != nil && ![superClass isEqual:[NSObject class]]) {
    NSString *superString = [self autogeneratedDescriptionOf:instance classType:superClass];
    [propPrint appendString:superString];
  }
  
  return propPrint;
}

+ (NSString *)autogeneratedDescriptionOf:(id)instance {
  NSString *headerString = [NSString stringWithFormat:@"%@:%p:: ",[instance class], instance];
  return [headerString stringByAppendingString:[self autogeneratedDescriptionOf:instance classType:[instance class]]];
}

@end
