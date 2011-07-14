#import "NKOAuthServiceTicket.h"


@interface NKOAuthServiceTicket ()
@property (strong, readwrite) NKOAuthMutableURLRequest *request;
@property (strong, readwrite) NSURLResponse *response;
@property (assign, readwrite) BOOL didSucceed;
@end

@implementation NKOAuthServiceTicket
@synthesize request = request_;
@synthesize response = response_;
@synthesize didSucceed = didSucceed_;

+ (id)ticketWithRequest:(NKOAuthMutableURLRequest *)request response:(NSURLResponse *)response didSucceed:(BOOL)success {
  return [[NKOAuthServiceTicket alloc] initWithRequest:request response:response didSucceed:success];
}

- (id)initWithRequest:(NKOAuthMutableURLRequest *)request response:(NSURLResponse *)response didSucceed:(BOOL)success {
  self = [super init];
  if (self) {
    self.request = request;
    self.response = response;
    self.didSucceed = success;
  }
  return self;
}

@end
