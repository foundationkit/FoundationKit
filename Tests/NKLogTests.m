#import "NKLogTests.h"

@implementation NKLogTests

- (void)setUp {
  [super setUp];
  
  // Set-up code here.
}

- (void)tearDown {
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testNSString {
  NSString *result = NKLogToStr(@"asd");
  NSString *should = @"@\"asd\" = asd";
  NSLog(@"%@ == %@", result, should);
}

@end
