#import "FKSynthesizeSingletonTests.h"

@interface FKTestSingleton : NSObject
@end

@implementation FKTestSingleton
+ (id)sharedInstance {
  FKDefineSingletonUsingBlock(^{
    return [[[self class] alloc] init];
  });
}
@end

@implementation FKSynthesizeSingletonTests

- (void)testSingletonAccessor {
  STAssertEquals([[FKTestSingleton sharedInstance] class], [FKTestSingleton class], @"singleton's class equals");
}

@end
