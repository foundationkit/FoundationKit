#import "NKOAuthToken.h"


@implementation NKOAuthToken
@synthesize key = key_;
@synthesize secret = secret_;

+ (id)tokenWithKey:(NSString *)key secret:(NSString *)secret {
	return [[NKOAuthToken alloc] initWithKey:key secret:secret];
}

+ (id)tokenWithUserDefaultsUsingServiceProviderName:(NSString *)provider prefix:(NSString *)prefix {
	return [[NKOAuthToken alloc] initWithUserDefaultsUsingServiceProviderName:provider prefix:prefix];
}

+ (id)tokenWithHTTPResponseBody:(NSString *)body {
	return [[NKOAuthToken alloc] initWithHTTPResponseBody:body];
}

- (id)init {
  return [self initWithKey:@"" secret:@""];
}

- (id)initWithCoder:(NSCoder *)coder {
  self = [super init];
	if (self) {
		[self setKey:[coder decodeObjectForKey:@"key"]];
		[self setSecret:[coder decodeObjectForKey:@"secret"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:self.key forKey:@"key"];
	[coder encodeObject:self.secret forKey:@"secret"];
}

- (id)initWithKey:(NSString *)key secret:(NSString *)secret {
  self = [super init];
  if (self) {
    self.key = key;
    self.secret = secret;
  }
  return self;
}

- (id)initWithHTTPResponseBody:(NSString *)body {
  self = [super init];
  if (self) {
    NSArray *pairs = [body componentsSeparatedByString:@"&"];
    for (NSString *pair in pairs) {
      NSArray *elements = [pair componentsSeparatedByString:@"="];
      if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token"]) {
        self.key = [elements objectAtIndex:1];
      } else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token_secret"]) {
        self.secret = [elements objectAtIndex:1];
      }
    }
  }
  return self;
}

- (id)initWithUserDefaultsUsingServiceProviderName:(NSString *)provider prefix:(NSString *)prefix {
  self = [super init];
  if (self) {
    NSString *theKey = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"OAUTH_%@_%@_KEY", prefix, provider]];
    NSString *theSecret = [[NSUserDefaults standardUserDefaults] stringForKey:[NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", prefix, provider]];
    
    if (theKey == NULL || theSecret == NULL) {
      return nil;
    }
    
    self.key = theKey;
    self.secret = theSecret;
  }
  return self;
}

- (int)storeInUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix {
	[[NSUserDefaults standardUserDefaults] setObject:self.key forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_KEY", prefix, provider]];
	[[NSUserDefaults standardUserDefaults] setObject:self.secret forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", prefix, provider]];
	[[NSUserDefaults standardUserDefaults] synchronize];
	return(0);
}

+ (void)removeFromUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix {
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_KEY", prefix, provider]];
	[[NSUserDefaults standardUserDefaults] setObject:nil forKey:[NSString stringWithFormat:@"OAUTH_%@_%@_SECRET", prefix, provider]];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
