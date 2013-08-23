// Part of FoundationKit http://foundationk.it
//
// isValidEmailAddress see http://stackoverflow.com/questions/3179859/regex-for-an-email-address-doesnt-work/8863823#8863823

#import <Foundation/Foundation.h>

@interface NSString (FKAdditions)

- (NSRange)fkit_stringRange;
- (NSString *)fkit_trimmed;
- (NSString *)fkit_URLEncodedString;
- (NSString *)fkit_URLDecodedString;

- (BOOL)fkit_containsString:(NSString *)string;
- (BOOL)fkit_containsString:(NSString *)string options:(NSStringCompareOptions)options;
- (BOOL)fkit_isEqualToStringIgnoringCase:(NSString *)otherString;

/**
 Replaces all occurences of two or more spaces in a row with one space, 
 e.g. "  I   like    FoundationKit   " -> " I like FoundationKit "
 The String doesn't get trimmed.
 
 @return A string that only contains one space in a row
 */
- (NSString *)fkit_stringByReplacingUnnecessaryWhitespace;

/**
 Replaces all occurences of two or more spaces in a row with one space and trim the string, 
 e.g. "  I   like    FoundationKit   " -> "I like FoundationKit"
 
 @return A string that only contains one space in a row and no space at the beginning and end
 */
- (NSString *)fkit_trimmedStringByReplacingUnnecessaryWhitespace;

/**
 Checks if the string is valid E-Mail address
 @return YES, if the string is a valid E-Mail address, NO otherwise
 */
- (BOOL)fkit_isValidEmailAddress;

/**
 Checks if the string is valid website address
 @return YES, if the string is a valid website address, NO otherwise
 */
- (BOOL)fkit_isValidWebAddress;

/**
 Returns first letter of the string
 @return first letter of the string, if string has length 0 it will return the empty string
 */
- (NSString *)fkit_firstLetter;

/**
 This method removes all characters from NSString that are no valid phone number characters.

 @return a sanitized phone number
 */
- (NSString *)fkit_sanitizedPhoneNumber;

@end
