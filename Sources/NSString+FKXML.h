// Part of FoundationKit http://foundationk.it
//
// Based on https://github.com/sbentzen/Google-Toolbox-for-Mac/blob/master/Foundation/GTMNSString+HTML.m

#import <Foundation/Foundation.h>

/**
 This category adds various methods to NSString for coping with XML/HTML.
 */
@interface NSString (FKXML)

/**
 * Returns a new string where XML entities are replace by their representation, e.g. &ouml; -> ö
 */
- (NSString *)fkit_stringByDecodingXMLEntities;

@end
