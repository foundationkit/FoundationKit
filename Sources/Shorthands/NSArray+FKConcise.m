// Part of FoundationKit http://foundationk.it

#import "NSArray+FKConcise.h"


@implementation NSArray (FKConcise)

- (BOOL)isEmpty {
  return self.count == 0;
}

- (id)firstObject {
  if (self.empty) {
    return nil;
  }
  
  return [self objectAtIndex:0];
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
    return [self objectAtIndex:index];
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
