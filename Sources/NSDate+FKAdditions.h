// Part of FoundationKit http://foundationk.it
//
// Derived from enormego's BSD-Licensed cocoa-helpers: http://github.com/enormego/cocoa-helpers

#import <Foundation/Foundation.h>

@interface NSDate (FKAdditions)

+ (NSDate *)fkit_dateWithString:(NSString *)dateString format:(NSString *)format;
+ (NSDate *)fkit_dateWithYear:(NSInteger)year;
+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month;
+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour;
+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute;
+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;

- (NSString *)fkit_relativeDateString;
- (NSString *)fkit_dateStringWithFormat:(NSString *)format;

- (BOOL)fkit_isBefore:(NSDate *)otherDate;
- (BOOL)fkit_isAfter:(NSDate *)otherDate;

- (BOOL)fkit_isToday;
- (BOOL)fkit_isYesterday;
- (BOOL)fkit_isTomorrow;
- (NSDate *)fkit_midnightDate;

- (NSDateComponents *)fkit_gregorianCalendarComponents;
- (NSInteger)fkit_secondComponent;
- (NSInteger)fkit_minuteComponent;
- (NSInteger)fkit_hourComponent;
- (NSInteger)fkit_dayComponent;
- (NSInteger)fkit_dayOfYearComponent;
- (NSInteger)fkit_weekdayComponent;
- (NSInteger)fkit_weekComponent;
- (NSInteger)fkit_weekOfYearComponent;
- (NSInteger)fkit_monthComponent;
- (NSInteger)fkit_yearComponent;

- (NSInteger)fkit_daysSinceDate:(NSDate *)date;
- (NSDate *)fkit_dateByAddingDays:(NSUInteger)days;
- (BOOL)fkit_isSameWeekAsDate:(NSDate *)date;
- (BOOL)fkit_isSameDayAsDate:(NSDate *)date;

@end
