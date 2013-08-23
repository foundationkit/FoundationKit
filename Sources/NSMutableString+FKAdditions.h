// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

@interface NSMutableString (FKAdditions)

/**
 This method is a shortcut for replacing all occurences of String "target" with "replacement"
 by performing a case-insensitive search on the whole string.
 */
- (NSUInteger)fkit_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;

@end
