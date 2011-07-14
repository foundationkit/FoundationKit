#import "NKOAuthRequestParameter.h"

#import "NSString+NKAdditions.h"


@implementation NKOAuthRequestParameter
@synthesize name = name_;
@synthesize value = value_;

- (void)dealloc {
  self.name = nil;
  self.value = nil;
}

+ (id)requestParameterWithName:(NSString *)name value:(NSString *)value {
  return [[NKOAuthRequestParameter alloc] initWithName:name value:value];
}

- (id)initWithName:(NSString *)name value:(NSString *)value {
  self = [super init];
  if (self) {
    self.name = name;
    self.value = value;
  }
  return self;
}

- (NSString *)URLEncodedName {
    return [self.name URLEncodedStringEscapingAllCharacters];
}

- (NSString *)URLEncodedValue {
    return [self.value URLEncodedStringEscapingAllCharacters];
}

- (NSString *)URLEncodedNameValuePair {
    return [NSString stringWithFormat:@"%@=%@", [self URLEncodedName], [self URLEncodedValue]];
}

@end
