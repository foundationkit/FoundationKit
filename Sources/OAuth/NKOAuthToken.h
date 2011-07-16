// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>

@interface NKOAuthToken : NSObject {
}
@property (copy) NSString *key;
@property (copy) NSString *secret;


+ (id)tokenWithKey:(NSString *)key secret:(NSString *)secret;
+ (id)tokenWithUserDefaultsUsingServiceProviderName:(NSString *)provider prefix:(NSString *)prefix;
+ (id)tokenWithHTTPResponseBody:(NSString *)body;
+ (void)removeFromUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix;

- (id)initWithKey:(NSString *)key secret:(NSString *)secret;
- (id)initWithUserDefaultsUsingServiceProviderName:(NSString *)provider prefix:(NSString *)prefix;
- (id)initWithHTTPResponseBody:(NSString *)body;
- (int)storeInUserDefaultsWithServiceProviderName:(NSString *)provider prefix:(NSString *)prefix;

@end
