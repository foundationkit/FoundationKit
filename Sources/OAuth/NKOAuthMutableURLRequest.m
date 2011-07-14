#import "NKOAuthMutableURLRequest.h"

#import "NKOAuthRequestParameter.h"
#import "NKOAuthHMACSHA1SignatureProvider.h"
#import "NSString+NKAdditions.h"


@interface NKOAuthMutableURLRequest ()
@property (copy, readwrite) NSString *signature;
@property (copy, readwrite) NSString *nonce;
@property (copy, readwrite) NSString *realm;
@property (copy, readwrite) NSString *timestamp;
@property (nonatomic, strong) NKOAuthConsumer *consumer;
@property (nonatomic, strong) NKOAuthToken *token;
@property (nonatomic, strong) id<NKOAuthSignatureProvider, NSObject> signatureProvider;
- (void)_generateTimestamp;
- (void)_generateNonce;
- (NSString *)_signatureBaseString;
- (NSArray *)_parameters;
- (void)_setParameters:(NSArray *)parameters;
@end

@implementation NKOAuthMutableURLRequest
@synthesize signature = signature_;
@synthesize nonce = nonce_;
@synthesize consumer = consumer_;
@synthesize token = token_;
@synthesize realm = realm_;
@synthesize signatureProvider = signatureProvider_;
@synthesize timestamp = timestamp_;

- (id)initWithURL:(NSURL *)url consumer:(NKOAuthConsumer *)consumer token:(NKOAuthToken *)token realm:(NSString *)realm signatureProvider:(id<NKOAuthSignatureProvider, NSObject>)provider {
  self = [super initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
  if (self) {
    self.consumer = consumer;
    self.token = (token == nil ? [NKOAuthToken new] : token);
    self.realm = (realm == nil ? [NSString new] : realm);
    self.signatureProvider = (provider == nil ? [NKOAuthHMACSHA1SignatureProvider new] : provider);
    
    [self _generateTimestamp];
    [self _generateNonce];
  }
  return self;
}

// DEVNOTE: Setting a timestamp and nonce to known values can be helpful for testing
- (id)initWithURL:(NSURL *)url consumer:(NKOAuthConsumer *)consumer token:(NKOAuthToken *)token realm:(NSString *)realm signatureProvider:(id<NKOAuthSignatureProvider, NSObject>)provider nonce:(NSString *)nonce timestamp:(NSString *)timestamp {
  self = [self initWithURL:url consumer:consumer token:token realm:realm signatureProvider:provider];
  if (self) {
    self.nonce = nonce;
    self.timestamp = timestamp;
  }  
  return self;
}

- (void)prepare {
  // Sign
  NSString *secret = [NSString stringWithFormat:@"%@&%@", self.consumer.secret, self.token.secret];
  self.signature = [self.signatureProvider signClearText:[self _signatureBaseString] withSecret:secret];
  
  // Set OAuth headers
  NSString *oauthToken;
  if ([token_.key isEqualToString:@""]) {
    oauthToken = @""; // not used on Request Token transactions
  } else {
    oauthToken = [NSString stringWithFormat:@"oauth_token=\"%@\", ", [self.token.key URLEncodedStringEscapingAllCharacters]];
  }
  
  NSString *oauthHeader = [NSString stringWithFormat:@"OAuth realm=\"%@\", oauth_consumer_key=\"%@\", %@oauth_signature_method=\"%@\", oauth_signature=\"%@\", oauth_timestamp=\"%@\", oauth_nonce=\"%@\", oauth_version=\"1.0\"",
                           [self.realm URLEncodedStringEscapingAllCharacters],
                           [self.consumer.key URLEncodedStringEscapingAllCharacters],
                           oauthToken,
                           [[self.signatureProvider name] URLEncodedStringEscapingAllCharacters],
                           [self.signature URLEncodedStringEscapingAllCharacters],
                           self.timestamp,
                           self.nonce];
  
  [self setValue:oauthHeader forHTTPHeaderField:@"Authorization"];
}

- (void)_generateTimestamp {
  self.timestamp = [NSString stringWithFormat:@"%d", time(NULL)];
}

- (void)_generateNonce {
  CFUUIDRef theUUID = CFUUIDCreate(NULL);
  self.nonce = CFBridgingRelease(CFUUIDCreateString(NULL, theUUID));
  CFRelease(theUUID);
}

static NSString *NSURLStringRemoveQuery(NSURL *url) {
  return [[[url absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0];
}

- (NSString *)_signatureBaseString {
  // Calling parameters is a bit expensive so only call it once
  NSArray *params = [self _parameters];
  
  // OAuth Spec, Section 9.1.1 "Normalize Request Parameters"
  // build a sorted array of both request parameters and OAuth header parameters
  //
  // DEVNOTE: 6 being the number of OAuth params in the Signature Base String
  NSMutableArray *parameterPairs = [[NSMutableArray alloc] initWithCapacity:(6 + [params count])]; 
  
  [parameterPairs addObject:[[NKOAuthRequestParameter requestParameterWithName:@"oauth_consumer_key" value:self.consumer.key] URLEncodedNameValuePair]];
  [parameterPairs addObject:[[NKOAuthRequestParameter requestParameterWithName:@"oauth_signature_method" value:[self.signatureProvider name]] URLEncodedNameValuePair]];
  [parameterPairs addObject:[[NKOAuthRequestParameter requestParameterWithName:@"oauth_timestamp" value:self.timestamp] URLEncodedNameValuePair]];
  [parameterPairs addObject:[[NKOAuthRequestParameter requestParameterWithName:@"oauth_nonce" value:self.nonce] URLEncodedNameValuePair]];
  [parameterPairs addObject:[[NKOAuthRequestParameter requestParameterWithName:@"oauth_version" value:@"1.0"] URLEncodedNameValuePair]];
  
  if (![self.token.key isEqualToString:@""]) {
    [parameterPairs addObject:[[NKOAuthRequestParameter requestParameterWithName:@"oauth_token" value:self.token.key] URLEncodedNameValuePair]];
  }
  for (NKOAuthRequestParameter *param in params) {
    [parameterPairs addObject:[param URLEncodedNameValuePair]];
  }
  
  NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
  NSString *normalizedRequestParameters = [sortedPairs componentsJoinedByString:@"&"];
  
  // OAuth Spec, Section 9.1.2 "Concatenate Request Elements"
  return [NSString stringWithFormat:@"%@&%@&%@",
          [self HTTPMethod],
          [NSURLStringRemoveQuery([self URL]) URLEncodedStringEscapingAllCharacters],
          [normalizedRequestParameters URLEncodedString]];
}

#pragma mark -
#pragma mark Private

- (NSArray *)_parameters {
  NSString *encodedParameters = nil;
  if ([[self HTTPMethod] isEqualToString:@"GET"] || [[self HTTPMethod] isEqualToString:@"DELETE"]) {
    encodedParameters = [[self URL] query];
  } else {
    // POST, PUT
    encodedParameters = [[NSString alloc] initWithData:[self HTTPBody] encoding:NSASCIIStringEncoding];
  }
  
  if ((encodedParameters == nil) || ([encodedParameters isEqualToString:@""])) {
    return nil;
  }
  
  NSArray *encodedParameterPairs = [encodedParameters componentsSeparatedByString:@"&"];
  NSMutableArray *requestParameters = [[NSMutableArray alloc] initWithCapacity:16];
  
  for (NSString *encodedPair in encodedParameterPairs) {
    NSArray *encodedPairElements = [encodedPair componentsSeparatedByString:@"="];
    NKOAuthRequestParameter *parameter = [NKOAuthRequestParameter requestParameterWithName:[[encodedPairElements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                           value:[[encodedPairElements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [requestParameters addObject:parameter];
  }
  
  return requestParameters;
}

- (void)_setParameters:(NSArray *)parameters {
  NSMutableString *encodedParameterPairs = [[NSMutableString alloc] initWithCapacity:256];
  NSInteger position = 1;
  for (NKOAuthRequestParameter *requestParameter in parameters) {
    [encodedParameterPairs appendString:[requestParameter URLEncodedNameValuePair]];
    if (position < [parameters count]) {
      [encodedParameterPairs appendString:@"&"];
    }
    position++;
  }
  
  if ([[self HTTPMethod] isEqualToString:@"GET"] || [[self HTTPMethod] isEqualToString:@"DELETE"]) {
    [self setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", NSURLStringRemoveQuery([self URL]), encodedParameterPairs]]];
  } else {
    // POST, PUT
    NSData *postData = [encodedParameterPairs dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    [self setHTTPBody:postData];
    [self setValue:[NSString stringWithFormat:@"%d", [postData length]] forHTTPHeaderField:@"Content-Length"];
    [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  }
}

@end
