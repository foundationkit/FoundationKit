#import "NSArray+NKBlocks.h"


@implementation NSArray (NKBlocks)

- (BOOL)all:(BOOL (^)(id))block {
  for (id obj in self) {
    if (!block(obj)) {
      return NO;
    }
  }
  return YES;
}

- (BOOL)any:(BOOL (^)(id))block {
  for (id obj in self) {
    if (block(obj)) {
      return YES;
    }
  }   
  return NO;
}

- (void)each:(void (^)(id))block {
  for (id obj in self) {
    block(obj);
  }
}

- (void)eachWithIndex:(void (^)(NSUInteger, id))block {
  NSUInteger index = 0;
  for (id obj in self) {
    block(index, obj);
    index++;
  }
}

- (NSArray *)select:(BOOL (^)(id))block {
    NSMutableArray *result = [NSMutableArray array];
  for (id obj in self) {
    if (block(obj)) {
      [result addObject:obj];
    }
  }
  return result;
}

- (NSArray *)map:(id (^)(id))block {
  NSMutableArray *result = [NSMutableArray array];
  for (id obj in self) {
    [result addObject:block(obj)];
  }
  return result;
}

- (id)collect:(id)initial withBlock:(id (^)(id,id))block {
  id result = initial;
  for (id obj in self) {
    result = block(result, obj);
  }
  return result;
}

@end
