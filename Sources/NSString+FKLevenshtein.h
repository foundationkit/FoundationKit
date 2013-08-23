// Part of FoundationKit http://foundationk.it
//
// Derived from Wikipedia: http://en.wikipedia.org/wiki/Levenshtein_distance

#import <Foundation/Foundation.h>

/**
 This category adds a method to NSString for fuzzy string matching using the Levenshtein-Algorithm.
 The Levenshtein distance between two strings is defined as the minimum number of edits needed to
 transform one string into the other, with the allowable edit operations being insertion, deletion,
 or substitution of a single character.
 
 E.g.
 The levenshtein distance between "kitten" and "sitting" is 3:
 kitten -> sitten, 
 sitten -> sittin,
 sittin -> sitting
 */
@interface NSString (FKLevenshtein)

/**
 Computes the levensthein-distance between self and the other string (case-insensitive).
 
 @param string the string to compute the levensthein-distance to
 @return the levensthein-distance between self and string
 */
- (NSInteger)fkit_levenshteinDistanceToString:(NSString *)string;

/**
 Computes the levensthein-distance between self and the other string (case-insensitive).
 
 @param string the string to compute the levensthein-distance to
 @param caseSensitive flag to determine whether comparison is case-sensitive or case-insensitive
 @return the levensthein-distance between self and string
 */
- (NSInteger)fkit_levenshteinDistanceToString:(NSString *)string caseSensitive:(BOOL)caseSensitive;

@end
