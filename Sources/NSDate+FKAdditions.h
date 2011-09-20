// Part of FoundationKit http://foundationk.it
//
// Derived from enormego's BSD-Licensed cocoa-helpers: http://github.com/enormego/cocoa-helpers

#import <Foundation/Foundation.h>

@interface NSDate (FKAdditions)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

- (NSString *)relativeDateString;
- (NSString *)dateStringWithFormat:(NSString *)format;

- (BOOL)isBefore:(NSDate *)otherDate;
- (BOOL)isAfter:(NSDate *)otherDate;

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (NSDate *)midnightDate;

@end
