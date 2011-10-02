#import "FKMutableIntArray.h"

@interface FKMutableIntArray () {
  CFMutableArrayRef arrayRef_;
}

@end

@implementation FKMutableIntArray

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle
////////////////////////////////////////////////////////////////////////

- (id)init {
  if ((self = [super init])) {
    arrayRef_ = CFArrayCreateMutable(NULL, 0, NULL);
  }
  
  return self;
}

- (void)dealloc {
  if (arrayRef_ != NULL) {
    CFRelease(arrayRef_);
    arrayRef_ = NULL;
  }
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark FKMutableIntArray
////////////////////////////////////////////////////////////////////////

- (CFMutableArrayRef)arrayRef {
  return arrayRef_;
}

- (NSUInteger)count {
  return CFArrayGetCount(arrayRef_);
}

- (BOOL)isEmpty {
  return self.count == 0;
}

- (void)addNumber:(NSInteger)number {
  CFArrayAppendValue(arrayRef_, (void *)number);
}

- (void)insertNumber:(NSInteger)number atIndex:(NSUInteger)index {
  if (index < self.count) {
    CFArrayInsertValueAtIndex(arrayRef_, index, (void*)number);
  }
}

- (void)removeAllNumbers {
  CFArrayRemoveAllValues(arrayRef_);
}

- (void)removeNumberAtIndex:(NSUInteger)index {
  if (index < self.count) {
    CFArrayRemoveValueAtIndex(arrayRef_, index);
  }
}

- (NSInteger)numberAtIndex:(NSUInteger)index {
  return (NSInteger)CFArrayGetValueAtIndex(arrayRef_, index);
}

- (NSInteger)numberOrNoValueAtIndex:(NSUInteger)index {
  if (index < self.count) {
    return (NSInteger)CFArrayGetValueAtIndex(arrayRef_, index);
  }
  
  return kFKMutableIntArrayNoValue;
}

- (NSInteger)firstNumber {
  return [self numberOrNoValueAtIndex:0];
}

- (NSInteger)lastNumber {
  return [self numberOrNoValueAtIndex:self.count-1];
}

- (NSUInteger)indexOfNumber:(NSInteger)number {
  for (NSUInteger index=0;index<self.count;index++) {
    if ([self numberAtIndex:index] == number) {
      return index;
    }
  }
  
  return NSNotFound;
}

@end
