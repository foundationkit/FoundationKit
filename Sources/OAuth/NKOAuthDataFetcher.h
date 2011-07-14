// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>
#import "NKOAuthMutableURLRequest.h"
#import "NKOAuthServiceTicket.h"


@interface NKOAuthDataFetcher : NSObject {
}

+ (id)fetcherWithRequest:(NKOAuthMutableURLRequest *)request delegate:(id)dlg didFinishSelector:(SEL)finSlc didFailSelector:(SEL)failSlc;

- (void)fetchDataWithRequest:(NKOAuthMutableURLRequest *)request delegate:(id)dlg didFinishSelector:(SEL)finSlc didFailSelector:(SEL)failSlc;
- (void)fetchData;

@end
