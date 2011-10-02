// Part of FoundationKit http://foundationk.it
//
// isBlank see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/object/blank.rb


#import <Foundation/Foundation.h>

@interface NSString (FKAdditions)

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

/**
 Replaces all occurences of two or more spaces in a row with one space, 
 e.g. "  I   like    FoundationKit   " -> " I like FoundationKit "
 The String doesn't get trimmed.
 
 @return A string that only contains one space in a row
 */
- (NSString *)stringByReplacingUnnecessaryWhitespace;

/**
 Replaces all occurences of two or more spaces in a row with one space and trim the string, 
 e.g. "  I   like    FoundationKit   " -> "I like FoundationKit"
 
 @return A string that only contains one space in a row and no space at the beginning and end
 */
- (NSString *)trimmedStringByReplacingUnnecessaryWhitespace;

@end
