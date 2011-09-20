#import "NSDate+FKAdditions.h"
#import "FKMath.h"

static NSDateFormatter *dateFormatter_ = nil;

NSDateFormatter* dateFormatter(void);

@implementation NSDate (FKAdditions)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
	if(dateString == nil) {
    return nil;
  }
  
  NSDateFormatter *formatter = dateFormatter();
	[formatter setDateFormat:format];
  
	return [formatter dateFromString:dateString];
}

- (NSString *)relativeDateString {
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
  
	return [self dateStringWithFormat:_(@"MM/dd/yy")];
}

- (NSString *)dateStringWithFormat:(NSString *)format {
  if(format == nil) {
    return nil;
  }
  
  NSDateFormatter* formatter = dateFormatter();
  [formatter setDateFormat:format];
  [formatter setAMSymbol:@"am"];
  [formatter setPMSymbol:@"pm"];
  
  return [formatter stringFromDate:self];
}

- (BOOL)isBefore:(NSDate *)otherDate {
	return [self timeIntervalSinceDate:otherDate] < 0;
}

- (BOOL)isAfter:(NSDate *)otherDate {
	return [self timeIntervalSinceDate:otherDate] > 0;
}

- (BOOL)isToday {
	return [[[NSDate date] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isYesterday {
	return [[[NSDate dateWithTimeIntervalSinceNow:-FKTimeIntervalDays(1)] midnightDate] isEqual:[self midnightDate]];
}

- (BOOL)isTomorrow {
	return [[[NSDate dateWithTimeIntervalSinceNow:FKTimeIntervalDays(1)] midnightDate] isEqual:[self midnightDate]];
}

- (NSDate *)midnightDate {
	return [[NSCalendar currentCalendar] dateFromComponents:[[NSCalendar currentCalendar] components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self]];
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