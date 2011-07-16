#import <Foundation/Foundation.h>

@interface NSString (NKAdditions)

// see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/blank.rb
- (BOOL)isBlank;
- (BOOL)isEmpty;
- (NSString *)presence;
- (NSRange)stringRange;
- (NSString *)trimmed;

- (NSString *)URLEncodedString;
- (NSString *)URLEncodedStringEscapingAllCharacters;

@end
