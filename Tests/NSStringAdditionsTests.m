#import "NSStringAdditionsTests.h"


@implementation NSStringAdditionsTests

- (void)testStringRange {
  STAssertEquals([@"" fkit_stringRange], NSMakeRange(0, 0), @"empty");
  STAssertEquals([@"asd" fkit_stringRange], NSMakeRange(0, 3), @"non empty");
}

- (void)testTrimmed {
  STAssertEqualObjects([@"  " fkit_trimmed], @"", @"only whitespace");
  STAssertEqualObjects([@"    " fkit_trimmed], @"", @"whitespace + tab");
  STAssertEqualObjects([@"" fkit_trimmed], @"", @"empty");
  STAssertEqualObjects([@"asd" fkit_trimmed], @"asd", @"no whitespace");
  STAssertEqualObjects([@"  asd  " fkit_trimmed], @"asd", @"leading/trailing whitespace");
  STAssertEqualObjects([@"  asd qwe " fkit_trimmed], @"asd qwe", @"leading/trailing whitespace, whitespace between words");
}

- (void)testLevenshtein {
  STAssertTrue([@"kitten" fkit_levenshteinDistanceToString:@"sitting"] == 3, @"Levenshtein failed for kitten - sitting");
  STAssertTrue([@"Saturday" fkit_levenshteinDistanceToString:@"Sunday"] == 3, @"Levenshtein failed for Saturday - Sunday");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"Test"] == 0, @"Levenshtein failed for Test - Test");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"Test2"] == 1, @"Levenshtein failed for Test - Test2");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"test" caseSensitive:YES] == 1, @"Levenshtein failed for Test - test");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"tst" caseSensitive:YES] == 2, @"Levenshtein failed for Test - tst");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"tst" caseSensitive:NO] == 1, @"Levenshtein failed for Test - tst");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"est"] == 1, @"Levenshtein failed for Test - est");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"Fest"] == 1, @"Levenshtein failed for Test - Fest");
  STAssertTrue([@"Test" fkit_levenshteinDistanceToString:@"Fst3"] == 3, @"Levenshtein failed for Test - Fst3");
}

- (void)testXMLDecoding {
  NSString *encoded1 = [@"&Auml;&Uuml;&Ouml;&auml;&uuml;&ouml;" fkit_stringByDecodingXMLEntities];
  NSString *encoded2 = [@"&lt;HTML&gt;" fkit_stringByDecodingXMLEntities];
  
  STAssertEqualObjects([@"ASDF" fkit_stringByDecodingXMLEntities], @"ASDF", @"XML-Decoding of entities doesn't work");
  STAssertEqualObjects(encoded1, @"ÄÜÖäüö", @"XML-Decoding of entities doesn't work");
  STAssertEqualObjects(encoded2, @"<HTML>", @"XML-Decoding of entities doesn't work");
}

@end
