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

- (NSUInteger)count {
  return CFArrayGetCount(arrayRef_);
}

- (void)addInt:(NSInteger)value {
  CFArrayAppendValue(arrayRef_, (void *)value);
}

- (NSInteger)intAtIndex:(NSUInteger)index {
  return (NSInteger)CFArrayGetValueAtIndex(arrayRef_, index);
}

- (NSInteger)firstInt {
  if (self.count > 0) {
    return [self intAtIndex:0];
  }
  
  return kFKMutableIntArrayNoValue;
}

- (NSInteger)lastInt {
  if (self.count > 0) {
    return [self intAtIndex:self.count-1];
  }
  
  return kFKMutableIntArrayNoValue;
}

@end
