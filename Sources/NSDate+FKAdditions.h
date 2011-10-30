// Part of FoundationKit http://foundationk.it
//
// Derived from enormego's BSD-Licensed cocoa-helpers: http://github.com/enormego/cocoa-helpers

#import <Foundation/Foundation.h>

@interface NSDate (FKAdditions)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;
+ (NSDate *)dateWithYear:(NSInteger)year;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (NSString *)relativeDateString;
- (NSString *)dateStringWithFormat:(NSString *)format;

- (BOOL)isBefore:(NSDate *)otherDate;
- (BOOL)isAfter:(NSDate *)otherDate;

- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (NSDate *)midnightDate;

- (NSDateComponents *)gregorianCalendarComponents;
- (NSInteger)secondComponent;
- (NSInteger)minuteComponent;
- (NSInteger)dayComponent;
- (NSInteger)weekdayComponent;
- (NSInteger)weekComponent;
- (NSInteger)monthComponent;
- (NSInteger)yearComponent;

- (NSInteger)daysSinceDate:(NSDate *)date;
- (NSDate *)dateByAddingDays:(NSUInteger)days;
- (BOOL)isSameWeekAsDate:(NSDate *)date;

@end
