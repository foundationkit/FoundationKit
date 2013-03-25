// Part of FoundationKit http://foundationk.it

#import "NSArray+FKConcise.h"

FKLoadCategory(NSArrayFKConcise);

@implementation NSArray (FKConcise)

- (BOOL)isEmpty {
  return self.count == 0;
}

- (id)firstObject {
  return [self objectOrNilAtIndex:0];
}

- (id)firstObjectMatchingPredicate:(NSPredicate *)predicate {
  NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
  
  if (filteredArray != nil) {
    return [filteredArray firstObject];
  }
  
  return nil;
}

- (id)objectOrNilAtIndex:(NSUInteger)index {
  if (index < self.count) {
    return self[index];
  }
  
  return nil;
}

- (NSArray *)arrayWithUniqueMembers {
	NSMutableArray *copy = [self mutableCopy];
	
  for (id object in self) {
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
  
	return copy;
}

@end
