#import "FKPathsTests.h"

@implementation FKPathsTests

- (void)testDocumentsPath {
  STAssertTrue([FKDocumentsDirectory() containsString:@"Documents"], @"Documents directory is wrong");
}

- (void)testApplicationSupportPath {
  STAssertTrue([FKApplicationSupportDirectory() containsString:@"Application Support"], @"Application Support directory is wrong");
}

- (void)testLibraryPath {
  STAssertTrue([FKLibraryDirectory() containsString:@"Library"], @"Library directory is wrong");
}

- (void)testCachePath {
  STAssertTrue([FKCacheDirectory() containsString:@"Cache"], @"Cache directory is wrong");
}

@end
