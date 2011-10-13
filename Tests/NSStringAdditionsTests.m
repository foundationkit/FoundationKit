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

- (void)testLevenshtein {
  STAssertTrue([@"kitten" levenshteinDistanceToString:@"sitting"] == 3, @"Levenshtein failed for kitten - sitting");
  STAssertTrue([@"Saturday" levenshteinDistanceToString:@"Sunday"] == 3, @"Levenshtein failed for Saturday - Sunday");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"Test"] == 0, @"Levenshtein failed for Test - Test");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"Test2"] == 1, @"Levenshtein failed for Test - Test2");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"test" caseSensitive:YES] == 1, @"Levenshtein failed for Test - test");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"tst" caseSensitive:YES] == 2, @"Levenshtein failed for Test - tst");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"tst" caseSensitive:NO] == 1, @"Levenshtein failed for Test - tst");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"est"] == 1, @"Levenshtein failed for Test - est");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"Fest"] == 1, @"Levenshtein failed for Test - Fest");
  STAssertTrue([@"Test" levenshteinDistanceToString:@"Fst3"] == 3, @"Levenshtein failed for Test - Fst3");
}

@end
