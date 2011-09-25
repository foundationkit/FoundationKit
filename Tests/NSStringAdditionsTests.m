#import "NSStringAdditionsTests.h"


@implementation NSStringAdditionsTests

- (void)testIsBlank {
  STAssertTrue([@"  " isBlank], @"only whitespace");
  STAssertTrue([@"    " isBlank], @"whitespace + tab");
  STAssertTrue([@"" isBlank], @"empty");
  STAssertFalse([@"asd" isBlank], @"no whitespace");
  STAssertFalse([@"  asd  " isBlank], @"leading/trailing whitespace");
}

- (void)testIsEmpty {
  STAssertFalse([@"  " isEmpty], @"only whitespace");
  STAssertFalse([@"    " isEmpty], @"whitespace + tab");
  STAssertTrue([@"" isEmpty], @"empty");
  STAssertFalse([@"asd" isEmpty], @"no whitespace");
  STAssertFalse([@"  asd  " isEmpty], @"leading/trailing whitespace");
}

- (void)testPresence {
  STAssertEquals([@"  " presence], (NSString *)nil, @"nil for blank");
  STAssertEquals([@"asd" presence], @"asd", @"self otherwise");
}

- (void)testStringRange {
  STAssertEquals([@"" stringRange], NSMakeRange(0, 0), @"empty");
  STAssertEquals([@"asd" stringRange], NSMakeRange(0, 3), @"non empty");
}

- (void)testTrimmed {
  STAssertEqualObjects([@"  " trimmed], @"", @"only whitespace");
  STAssertEqualObjects([@"    " trimmed], @"", @"whitespace + tab");
  STAssertEqualObjects([@"" trimmed], @"", @"empty");
  STAssertEqualObjects([@"asd" trimmed], @"asd", @"no whitespace");
  STAssertEqualObjects([@"  asd  " trimmed], @"asd", @"leading/trailing whitespace");
  STAssertEqualObjects([@"  asd qwe " trimmed], @"asd qwe", @"leading/trailing whitespace, whitespace between words");
}

@end
