#import "FKMutableFloatArrayTests.h"

@implementation FKMutableFloatArrayTests

- (void)setUp {
  array = [[FKMutableFloatArray alloc] init];
  STAssertNotNil(array, @"Could not create test subject.");
}

- (void)testEmpty {
  STAssertTrue(array.empty, @"Empty array does return NO on isEmpty");
  STAssertTrue(array.count == 0, @"Empty array does return count != 0");
}

- (void)testInsert {
  for (int i=0;i<20;i++) {
    [array addNumber:(CGFloat)i];
  }
  
  STAssertTrue(array.count == 20, @"Array doesn't hold 20 elements");
}

- (void)testIndex {
  for (int i=0;i<20;i++) {
    [array addNumber:(CGFloat)i];
  }
  
  for (int i=0;i<20;i++) {
    STAssertTrue([array numberAtIndex:i] == (CGFloat)i, @"numberAtIndex doesn't return right number");
    STAssertTrue([array indexOfNumber:(CGFloat)i] == i, @"indexOfNumber doesn't return right index");
  }
}

@end
