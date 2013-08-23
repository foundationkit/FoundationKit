#import "NSDate+FKAdditions.h"
#import "FKMath.h"

FKLoadCategory(NSDateFKAdditions);

static NSDateFormatter *dateFormatter_ = nil;

NSDateFormatter* dateFormatter(void);

@implementation NSDate (FKAdditions)

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class Methods
////////////////////////////////////////////////////////////////////////

+ (NSDate *)fkit_dateWithString:(NSString *)dateString format:(NSString *)format {
	if(dateString == nil) {
    return nil;
  }
  
  NSDateFormatter *formatter = dateFormatter();
	[formatter setDateFormat:format];
  
	return [formatter dateFromString:dateString];
}

+ (NSDate *)fkit_dateWithYear:(NSInteger)year {
	return [self fkit_dateWithYear:year month:0 day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month {
	return [self fkit_dateWithYear:year month:month day:0 hour:0 minute:0 second:0];
}

+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
	return [self fkit_dateWithYear:year month:month day:day hour:0 minute:0 second:0];
}

+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour {
	return [self fkit_dateWithYear:year month:month day:day hour:hour minute:0 second:0];
}

+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute {
	return [self fkit_dateWithYear:year month:month day:day hour:hour minute:minute second:0];
}

+ (NSDate *)fkit_dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
	NSDateComponents *comps = [[NSDateComponents alloc] init];
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  
	[comps setYear:year];
	[comps setMonth:month];
	[comps setDay:day];
	[comps setHour:hour];
	[comps setMinute:minute];
	[comps setSecond:second];
  
	return [gregorian dateFromComponents:comps];
}

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Instance Methods
////////////////////////////////////////////////////////////////////////

- (NSString *)fkit_relativeDateString {
	NSTimeInterval time = [self timeIntervalSince1970];
	NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
	NSTimeInterval diff = now - time;
  
	if(diff < FKTimeIntervalSeconds(10.)) {
		return _(@"just now");	
	} else if(diff < FKTimeIntervalMinutes(1.)) {
		return _([NSString stringWithFormat:@"%d seconds ago", (int)diff]);
	}
  
	diff = round(diff/FKTimeIntervalMinutes(1.));
	if(diff < 60.) {
		if(diff == 1.) {
			return _([NSString stringWithFormat:@"%d minute ago", (int)diff]);
		} else {
			return _([NSString stringWithFormat:@"%d minutes ago", (int)diff]);
		}
	}
  
	diff = round(diff/60.);
	if(diff < 24.) {
		if(diff == 1.) {
			return _([NSString stringWithFormat:@"%d hour ago", (int)diff]);
		} else {
			return _([NSString stringWithFormat:@"%d hours ago", (int)diff]);
		}
	}
  
	if(diff < 7.) {
		if(diff == 1.) {
			return _([NSString stringWithFormat:@"yesterday"]);
		} else {
			return _([NSString stringWithFormat:@"%d days ago", (int)diff]);
		}
	}
  
	return [self fkit_dateStringWithFormat:_(@"MM/dd/yy")];
}

- (NSString *)fkit_dateStringWithFormat:(NSString *)format {
  if(format == nil) {
    return nil;
  }
  
  NSDateFormatter* formatter = dateFormatter();
  [formatter setDateFormat:format];
  [formatter setAMSymbol:@"am"];
  [formatter setPMSymbol:@"pm"];
  
  return [formatter stringFromDate:self];
}

- (BOOL)fkit_isBefore:(NSDate *)otherDate {
	return [self timeIntervalSinceDate:otherDate] < 0;
}

- (BOOL)fkit_isAfter:(NSDate *)otherDate {
	return [self timeIntervalSinceDate:otherDate] > 0;
}

- (BOOL)fkit_isToday {
	return [[[NSDate date] fkit_midnightDate] isEqual:[self fkit_midnightDate]];
}

- (BOOL)fkit_isYesterday {
	return [[[NSDate dateWithTimeIntervalSinceNow:-FKTimeIntervalDays(1)] fkit_midnightDate] isEqual:[self fkit_midnightDate]];
}

- (BOOL)fkit_isTomorrow {
	return [[[NSDate dateWithTimeIntervalSinceNow:FKTimeIntervalDays(1)] fkit_midnightDate] isEqual:[self fkit_midnightDate]];
}

- (NSDate *)fkit_midnightDate {
	return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
}

- (NSDateComponents *)fkit_gregorianCalendarComponents {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *components = [gregorian components:(NSSecondCalendarUnit |
                                                        NSMinuteCalendarUnit |
                                                        NSHourCalendarUnit |
                                                        NSDayCalendarUnit |
                                                        NSWeekdayCalendarUnit |
                                                        NSWeekCalendarUnit |
                                                        NSWeekOfYearCalendarUnit |
                                                        NSMonthCalendarUnit |
                                                        NSYearCalendarUnit) fromDate:self];
	return components;
}

- (NSInteger)fkit_secondComponent {
	return [[self fkit_gregorianCalendarComponents] second];
}

- (NSInteger)fkit_minuteComponent {
	return [[self fkit_gregorianCalendarComponents] minute];
}

- (NSInteger)fkit_hourComponent {
	return [[self fkit_gregorianCalendarComponents] hour];
}

- (NSInteger)fkit_dayComponent {
	return [[self fkit_gregorianCalendarComponents] day];
}

- (NSInteger)fkit_dayOfYearComponent {
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSUInteger dayOfYear = [gregorian ordinalityOfUnit:NSDayCalendarUnit
                                              inUnit:NSYearCalendarUnit
                                             forDate:self];
  return dayOfYear;
}

- (NSInteger)fkit_weekdayComponent {
	return [[self fkit_gregorianCalendarComponents] weekday];
}

- (NSInteger)fkit_weekComponent {
	return [[self fkit_gregorianCalendarComponents] week];
}

- (NSInteger)fkit_weekOfYearComponent {
  return [[self fkit_gregorianCalendarComponents] weekOfYear];
}

- (NSInteger)fkit_monthComponent {
	return [[self fkit_gregorianCalendarComponents] month];
}

- (NSInteger)fkit_yearComponent {
	return [[self fkit_gregorianCalendarComponents] year];
}

- (NSInteger)fkit_daysSinceDate:(NSDate *)date {
  NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
  NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *components = [calendar components:unitFlags fromDate:date toDate:self options:0];

  if (components.hour > 0 || components.minute > 0) {
    components.day++;
  }

  return components.day;
}

- (NSDate *)fkit_dateByAddingDays:(NSUInteger)days {
  NSCalendar *calender = [NSCalendar currentCalendar];
  NSDateComponents *components = [[NSDateComponents alloc] init];
  
  components.day = days;
  
  return [calender dateByAddingComponents:components toDate:self options:0];
}

// This hard codes the assumption that a week is 7 days
- (BOOL)fkit_isSameWeekAsDate:(NSDate *)date {
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (self.fkit_weekComponent != date.fkit_weekComponent) {
    return NO;
  }
	
	return (ABS([self timeIntervalSinceDate:date]) < FKTimeIntervalDays(7));
}

- (BOOL)fkit_isSameDayAsDate:(NSDate *)date {
  return (self.fkit_yearComponent == date.fkit_yearComponent &&
          self.fkit_monthComponent == date.fkit_monthComponent &&
          self.fkit_dayComponent == date.fkit_dayComponent);
}

@end

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Helper Functions
////////////////////////////////////////////////////////////////////////

NSDateFormatter* dateFormatter(void) {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter_ = [[NSDateFormatter alloc] init];
  });
  
  return dateFormatter_;
}