#import "FKSynthesizeSingletonTests.h"

@interface FKTestSingleton : NSObject
@end
@implementation FKTestSingleton
  FKSynthesizeSingletonForClass(FKTestSingleton);
@end

@implementation FKSynthesizeSingletonTests

- (void)testSingletonAccessor {
  STAssertEquals([[FKTestSingleton sharedFKTestSingleton] class], [FKTestSingleton class], @"singleton's class equals");
}

@end
