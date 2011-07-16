#import "NKOAuthDataFetcher.h"

@interface NKOAuthDataFetcher ()
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NKOAuthMutableURLRequest *request;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL didFinishSelector;
@property (nonatomic, assign) SEL didFailSelector;
@end


@implementation NKOAuthDataFetcher
@synthesize connection = connection_;
@synthesize response = response_;
@synthesize responseData = responseData_;
@synthesize request = request_;
@synthesize delegate = delegate_;
@synthesize didFinishSelector = didFinishSelector_;
@synthesize didFailSelector = didFailSelector_;

+ (id)fetcherWithRequest:(NKOAuthMutableURLRequest *)request delegate:(id)dlg didFinishSelector:(SEL)finSlc didFailSelector:(SEL)failSlc {
  NKOAuthDataFetcher *fetcher = [NKOAuthDataFetcher new];
  fetcher.request = request;
  fetcher.delegate = dlg;
  fetcher.didFinishSelector = finSlc;
  fetcher.didFailSelector = failSlc;
  return fetcher;
}

- (void)fetchDataWithRequest:(NKOAuthMutableURLRequest *)request delegate:(id)dlg didFinishSelector:(SEL)finSlc didFailSelector:(SEL)failSlc {
  self.request = request;
  self.delegate = dlg; 
  self.didFinishSelector = finSlc;
  self.didFailSelector = failSlc;
  [self fetchData];
}

- (void)fetchData {
  [request_ prepare];
  
  self.connection = [NSURLConnection connectionWithRequest:request_ delegate:self];
  if (connection_) {
    self.responseData = [NSMutableData data];
  } else {
    NKOAuthServiceTicket *ticket = [[NKOAuthServiceTicket alloc] initWithRequest:request_ response:nil didSucceed:NO];
    [delegate_ performSelector:didFailSelector_ withObject:ticket withObject:nil];
  }
}

- (void)dealloc {
  self.connection = nil;
  self.responseData = nil;
  self.response = nil;
  self.request = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
  self.response = response;
  [responseData_ setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
  [responseData_ appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
  BOOL success = [(NSHTTPURLResponse *)response_ statusCode] < 400;
  NKOAuthServiceTicket *ticket = [[NKOAuthServiceTicket alloc] initWithRequest:request_ response:response_ didSucceed:success];
  [delegate_ performSelector:didFinishSelector_ withObject:ticket withObject:responseData_];
  
  self.connection = nil;
  self.response = nil;
  self.responseData = nil;
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
  NKOAuthServiceTicket *ticket = [[NKOAuthServiceTicket alloc] initWithRequest:request_ response:response_ didSucceed:NO];
  [delegate_ performSelector:didFailSelector_ withObject:ticket withObject:error];
  
  self.connection = nil;
  self.response = nil;
  self.responseData = nil;
}

@end
