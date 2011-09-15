#import <Foundation/Foundation.h>

@interface NSString (FKAdditions)

// see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/blank.rb
- (BOOL)isBlank;
- (BOOL)isEmpty;
- (NSString *)presence;
- (NSRange)stringRange;
- (NSString *)trimmed;
- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

- (BOOL)containsString:(NSString *)string;
- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)isEqualToStringIgnoringCase:(NSString*)otherString;
@end
