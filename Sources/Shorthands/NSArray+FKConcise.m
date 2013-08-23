// Part of FoundationKit http://foundationk.it

#import "NSArray+FKConcise.h"

FKLoadCategory(NSArrayFKConcise);

@implementation NSArray (FKConcise)

- (id)fkit_firstObjectMatchingPredicate:(NSPredicate *)predicate {
  NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
  
  if (filteredArray != nil) {
    return [filteredArray firstObject];
  }
  
  return nil;
}

- (id)fkit_objectOrNilAtIndex:(NSUInteger)index {
  if (index < self.count) {
    return self[index];
  }
  
  return nil;
}

- (NSArray *)fkit_arrayWithUniqueMembers {
	NSMutableArray *copy = [self mutableCopy];
	
  for (id object in self) {
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
  
	return copy;
}

@end
