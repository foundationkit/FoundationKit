// Part of FoundationKit http://foundationk.it
//
// Derived from Jon Crosby's MIT-licensed OAuthConsumer: http://oauth.googlecode.com/svn/code/obj-c/OAuthConsumer/

#import <Foundation/Foundation.h>


@interface NKOAuthRequestParameter : NSObject {
}
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *value;

+ (id)requestParameterWithName:(NSString *)name value:(NSString *)value;
- (id)initWithName:(NSString *)name value:(NSString *)value;

- (NSString *)URLEncodedName;
- (NSString *)URLEncodedValue;
- (NSString *)URLEncodedNameValuePair;

@end
