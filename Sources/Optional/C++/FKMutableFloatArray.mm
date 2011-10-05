#import "FKMutableFloatArray.h"
#include <vector>
#include <algorithm>

@interface FKMutableFloatArray () {
  std::vector<CGFloat> fk_array;
}

@end

@implementation FKMutableFloatArray

- (NSUInteger)count {
  return fk_array.size();
}

- (BOOL)isEmpty {
  return self.count == 0;
}

- (void)addNumber:(CGFloat)number {
  fk_array.push_back(number);
}

- (void)insertNumber:(CGFloat)number atIndex:(NSUInteger)index {
  if (index < self.count) {
    fk_array.insert(fk_array.begin()+index, number);
  }
}

- (void)removeAllNumbers {
  fk_array.clear();
}

- (void)removeNumberAtIndex:(NSUInteger)index {
  if (index < self.count) {
    fk_array.erase(fk_array.begin()+index);
  }
}

- (CGFloat)numberAtIndex:(NSUInteger)index {
  return fk_array[index];
}

- (CGFloat)numberOrNoValueAtIndex:(NSUInteger)index {
  if (index < fk_array.size()) {
    return fk_array[index];
  }
  
  return kFKMutableFloatArrayNoValue;
}

- (CGFloat)firstNumber {
  return [self numberOrNoValueAtIndex:0];
}

- (CGFloat)lastNumber {
  return [self numberOrNoValueAtIndex:self.count-1];
}

- (NSUInteger)indexOfNumber:(CGFloat)number {
  std::vector<CGFloat>::iterator iterator = find(fk_array.begin(),fk_array.end(),number);
  
  if (iterator == fk_array.end() && *iterator != number) {
    return NSNotFound;
  }
  
  return (NSUInteger)(iterator-fk_array.begin());
}


@end
