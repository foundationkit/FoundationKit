// Part of FoundationKit http://foundationk.it
//
//  Code optimized and adapted from http://www.cocoadev.com/index.pl?BaseSixtyFour

#import <Foundation/Foundation.h>


@interface NSData (NKBase64)

+ (NSData *)dataWithBase64String:(NSString *)string;
- (NSString *)base64String;

@end
