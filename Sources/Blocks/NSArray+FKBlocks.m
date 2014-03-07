// Part of FoundationKit http://foundationk.it

#import "NSArray+FKBlocks.h"

FKLoadCategory(NSArrayFKBlocks);

@implementation NSArray (FKBlocks)

- (BOOL)fkit_all:(BOOL (^)(id object))block {
  for (id object in self) {
    if (!block(object)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)fkit_any:(BOOL (^)(id object))block {
  for (id object in self) {
    if (block(object)) {
      return YES;
    }
  }
  return NO;
}

- (NSArray *)fkit_filter:(BOOL (^)(id object))block {
  NSMutableArray *result = [NSMutableArray array];
  for (id object in self) {
    if (block(object)) {
      [result addObject:object];
    }
  }
  return result;
}

- (NSArray *)fkit_map:(id (^)(id object))block {
  NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.count];
  for (id object in self) {
    id mappedResult = block(object);
    if (mappedResult != nil) {
      [result addObject:mappedResult];
    }
  }
  return result;
}

@end