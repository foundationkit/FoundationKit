// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>


@protocol NKOAuthSignatureProvider

- (NSString *)name;
- (NSString *)signClearText:(NSString *)text withSecret:(NSString *)secret;

@end
