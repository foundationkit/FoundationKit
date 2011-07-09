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
  NSString *in1 = @"test1";
  NSString *result = NKLogToStr(123, @"asd", 123, in1, NSMakeRect(100,200,300,400), nil, 123, in1);
  NSLog(@"%@", result);
}

@end
