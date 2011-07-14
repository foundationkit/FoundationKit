#import "NKOAuthConsumer.h"


@implementation NKOAuthConsumer
@synthesize key = key_;
@synthesize secret = secret_;

+ (id)consumerWithKey:(NSString *)key secret:(NSString *)secret {
	return [[NKOAuthConsumer alloc] initWithKey:key secret:secret];
}

- (id)initWithKey:(NSString *)key secret:(NSString *)secret {
  self = [super init];
  if (self) {
    self.key = key;
    self.secret = secret;
  }
	return self;
}



@end
