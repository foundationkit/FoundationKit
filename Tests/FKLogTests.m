#import "FKLogTests.h"
#import "FKLog.h"
#include <limits.h>

@implementation FKLogTests

- (void)testLog {
  NSString *string = @"qwe";
  NSObject *whatever = nil;
  NSObject *something = [[NSObject alloc] init];
  int notAPointer = 1234;
  
  NSString *output = FKLogToString("a", @"asd", string, notAPointer, whatever, something);
  NSString *expected = @"[FKLogTests.m:13] \"a\" = a asd string = qwe notAPointer = 1234 whatever = (null) something = <NSObject: ";
  STAssertTrue([output hasPrefix:expected], @"FKLogString failed: output: %@", output);
}

- (void)testULLONG_MAX {
  unsigned long long value = ULLONG_MAX;
  NSString *output = FKLogToString(value);
  NSString *expected = @"[FKLogTests.m:20] value = 18446744073709551615";
  STAssertEqualObjects(expected, output, @"FKLogString failed");
}

- (void)testStructs {
  /*NSRange range = NSMakeRange(2, 5);
  NSString *output = FKLogToString(range);
  NSString *expected = @"[FKLogTests.m:27] range = {loc=2,len=5}";
  
  STAssertEqualObjects(expected, output, @"FKLogString failed with structs");*/
}

@end
