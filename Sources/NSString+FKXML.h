// Part of FoundationKit http://foundationk.it
//
// Contains stuff from http://stackoverflow.com/questions/1105169/html-character-decoding-in-objective-c-cocoa-touch

#import <Foundation/Foundation.h>

/**
 This category adds various methods to NSString for coping with XML/HTML.
 */
@interface NSString (FKXML)

/**
 * Returns a new string where XML entities are replace by their representation, e.g. &ouml; -> ö
 */
- (NSString *)stringByDecodingXMLEntities;

@end
