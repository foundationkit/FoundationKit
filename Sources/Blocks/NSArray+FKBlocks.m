// Part of FoundationKit http://foundationk.it

#import "NSArray+FKBlocks.h"

FKLoadCategory(NSArrayFKBlocks);

@implementation NSArray (FKBlocks)

- (BOOL)all:(BOOL (^)(id object))block {
  for (id object in self) {
    if (!block(object)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)any:(BOOL (^)(id object))block {
  for (id object in self) {
    if (block(object)) {
      return YES;
    }
  }   
  return NO;
}

- (void)each:(void (^)(id object))block {
  for (id object in self) {
    block(object);
  }
}

- (void)eachWithIndex:(void (^)(NSUInteger index, id object))block {
  NSUInteger index = 0;
  for (id object in self) {
    block(index, object);
    index++;
  }
}

- (NSArray *)select:(BOOL (^)(id object))block {
    NSMutableArray *result = [NSMutableArray array];
  for (id object in self) {
    if (block(object)) {
      [result addObject:object];
    }
  }
  return result;
}

- (NSArray *)map:(id (^)(id object))block {
  NSMutableArray *result = [NSMutableArray array];
  for (id object in self) {
    [result addObject:block(object)];
  }
  return result;
}

- (id)inject:(id)initial withBlock:(id (^)(id memo, id object))block {
  id memo = initial;
  for (id object in self) {
    memo = block(memo, object);
  }
  return memo;
}

@end
