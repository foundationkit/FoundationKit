#import "NKOAuthHMACSHA1SignatureProvider.h"

#import "NSData+NKCrypto.h"
#import "NSData+NKBase64.h"


@implementation NKOAuthHMACSHA1SignatureProvider

- (NSString *)name {
  return @"HMAC-SHA1";
}

- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret {
  NSData *textData = [text dataUsingEncoding:NSUTF8StringEncoding];
  NSData *hmac = [textData HMACWithAlgorithm:kCCHmacAlgSHA1 key:secret];  
  return [hmac base64String];
}

@end
