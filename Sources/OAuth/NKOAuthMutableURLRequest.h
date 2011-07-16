// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>

#import "NKOAuthToken.h"
#import "NKOAuthConsumer.h"
#import "NKOAuthSignatureProvider.h"


@interface NKOAuthMutableURLRequest : NSMutableURLRequest {
}
@property (copy, readonly) NSString *signature;
@property (copy, readonly) NSString *nonce;

- (id)initWithURL:(NSURL *)url consumer:(NKOAuthConsumer *)consumer token:(NKOAuthToken *)token realm:(NSString *)realm signatureProvider:(id<NKOAuthSignatureProvider, NSObject>)provider;
- (id)initWithURL:(NSURL *)url consumer:(NKOAuthConsumer *)consumer token:(NKOAuthToken *)token realm:(NSString *)realm signatureProvider:(id<NKOAuthSignatureProvider, NSObject>)provider nonce:(NSString *)aNonce timestamp:(NSString *)aTimestamp;
- (void)prepare;

@end
