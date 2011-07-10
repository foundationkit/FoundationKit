#import "NKSynthesizeSingletonTests.h"

@interface NKTestSingleton : NSObject
@end
@implementation NKTestSingleton
  NKSynthesizeSingletonForClass(NKTestSingleton);
@end

@implementation NKSynthesizeSingletonTests

- (void)testSingletonAccessor {
  STAssertEquals([[NKTestSingleton sharedNKTestSingleton] class], [NKTestSingleton class], @"singleton's class equals");
}

@end
