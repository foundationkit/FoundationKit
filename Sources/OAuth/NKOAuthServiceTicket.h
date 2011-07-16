// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>

#import "NKOAuthMutableURLRequest.h"


@interface NKOAuthServiceTicket : NSObject {
}
@property (strong, readonly) NKOAuthMutableURLRequest *request;
@property (strong, readonly) NSURLResponse *response;
@property (assign, readonly) BOOL didSucceed;

+ (id)ticketWithRequest:(NKOAuthMutableURLRequest *)request response:(NSURLResponse *)response didSucceed:(BOOL)success;
- (id)initWithRequest:(NKOAuthMutableURLRequest *)request response:(NSURLResponse *)response didSucceed:(BOOL)success;

@end
