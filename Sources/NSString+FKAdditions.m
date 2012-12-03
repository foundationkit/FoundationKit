#import "NSString+FKAdditions.h"

FKLoadCategory(NSStringFKAdditions);

@implementation NSString (FKAdditions)

- (BOOL)isBlank {
  return [[self trimmed] isEmpty];
}

- (BOOL)isEmpty {
  return ([self length] == 0);
}

- (NSString *)presence {
  if([self isBlank]) {
    return nil;
  } else {
    return self;
  }
}

- (NSRange)stringRange {
  return NSMakeRange(0, [self length]);
}

- (NSString *)trimmed {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)URLEncodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           NULL,
                                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (NSString*)URLDecodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                           (__bridge CFStringRef)self,
                                                                                                           CFSTR(""),
                                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (BOOL)containsString:(NSString *)string {
	return [self containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)containsString:(NSString *)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

- (BOOL)isEqualToStringIgnoringCase:(NSString*)otherString {
	if(!otherString) {
		return NO;
  }
  
	return NSOrderedSame == [self compare:otherString options:NSCaseInsensitiveSearch + NSWidthInsensitiveSearch];
}

- (NSString *)stringByReplacingUnnecessaryWhitespace {
  NSError *error = nil;
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[ ]{2,}"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:&error];
  
  if (regex == nil) {
    FKLogDebug(@"Couldn't replace unneccessary whitespace because regex couldn't be created: %@", [error localizedDescription]);
    return self;
  } 
  
  return [regex stringByReplacingMatchesInString:self
                                         options:0
                                           range:self.stringRange
                                    withTemplate:@" "];
}

- (NSString *)trimmedStringByReplacingUnnecessaryWhitespace {
  return [[self stringByReplacingUnnecessaryWhitespace] trimmed];
}

- (BOOL)isValidEmailAddress {
  // Regexp from -[NSString(NSEmailAddressString) mf_isLegalEmailAddress] in /System/Library/PrivateFrameworks/MIME.framework
  NSString *emailRegex = @"^[[:alnum:]!#$%&'*+/=?^_`{|}~-]+((\\.?)[[:alnum:]!#$%&'*+/=?^_`{|}~-]+)*@[[:alnum:]-]+(\\.[[:alnum:]-]+)*(\\.[[:alpha:]]+)+$";
  NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

  return [emailPredicate evaluateWithObject:self];
}

- (NSString *)firstLetter {
  if (self.length <= 1)
    return self;
  return [self substringToIndex:1];
}

@end
