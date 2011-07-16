// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>


@interface NKOAuthConsumer : NSObject {
}
@property (copy, readwrite) NSString *key;
@property (copy, readwrite) NSString *secret;

+ (id)consumerWithKey:(NSString *)key secret:(NSString *)secret;
- (id)initWithKey:(NSString *)key secret:(NSString *)secret;

@end
