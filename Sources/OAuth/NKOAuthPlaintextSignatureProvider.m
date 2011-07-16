#import "NKOAuthPlaintextSignatureProvider.h"


@implementation NKOAuthPlaintextSignatureProvider

- (NSString *)name {
  return @"PLAINTEXT";
}

- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret {
  return secret;
}

@end
