#import "NSString+FKAdditions.h"

FKLoadCategory(NSStringFKAdditions);

static NSMutableDictionary *fk_checkedWebAddresses = nil;
static NSLock *fk_checkedWebAddressesLock = nil;
static NSMutableDictionary *fk_checkedEmailAddresses = nil;
static NSLock *fk_checkedEmailAddressesLock = nil;

static void __attribute__((constructor)) FKInitLocks(void) {
  fk_checkedWebAddressesLock = [[NSLock alloc] init];
  fk_checkedEmailAddressesLock = [[NSLock alloc] init];
}

static NSNumber* FKCachedWebAddressValue(NSString *string) {
  NSNumber *value = nil;

  [fk_checkedWebAddressesLock lock];
  value = fk_checkedWebAddresses[string];
  [fk_checkedWebAddressesLock unlock];

  return value;
}

static NSNumber* FKCachedEmailAddressValue(NSString *string) {
  NSNumber *value = nil;

  [fk_checkedEmailAddressesLock lock];
  value = fk_checkedEmailAddresses[string];
  [fk_checkedEmailAddressesLock unlock];

  return value;
}

static void FKCacheWebAddressValue(NSString *string, BOOL isValidWebAddress) {
  [fk_checkedWebAddressesLock lock];

  if (fk_checkedWebAddresses == nil) {
    fk_checkedWebAddresses = [NSMutableDictionary dictionary];
  }

  fk_checkedWebAddresses[string] = @(isValidWebAddress);

  [fk_checkedWebAddressesLock unlock];
}

static void FKCacheEmailAddressValue(NSString *string, BOOL isValidEmailAddress) {
  [fk_checkedEmailAddressesLock lock];

  if (fk_checkedEmailAddresses == nil) {
    fk_checkedEmailAddresses = [NSMutableDictionary dictionary];
  }

  fk_checkedEmailAddresses[string] = @(isValidEmailAddress);

  [fk_checkedEmailAddressesLock unlock];
}

@implementation NSString (FKAdditions)

- (NSRange)fkit_stringRange {
  return NSMakeRange(0, [self length]);
}

- (NSString *)fkit_trimmed {
  return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)fkit_URLEncodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                           (__bridge CFStringRef)self,
                                                                                           NULL,
                                                                                           CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (NSString*)fkit_URLDecodedString {
  NSString *result = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                           (__bridge CFStringRef)self,
                                                                                                           CFSTR(""),
                                                                                                           kCFStringEncodingUTF8);
  return result;
}

- (BOOL)fkit_containsString:(NSString *)string {
	return [self fkit_containsString:string options:NSCaseInsensitiveSearch];
}

- (BOOL)fkit_containsString:(NSString *)string options:(NSStringCompareOptions)options {
	return [self rangeOfString:string options:options].location == NSNotFound ? NO : YES;
}

- (BOOL)fkit_isEqualToStringIgnoringCase:(NSString*)otherString {
	if(otherString == nil) {
		return NO;
  }
  
	return NSOrderedSame == [self compare:otherString options:NSCaseInsensitiveSearch | NSWidthInsensitiveSearch];
}

- (NSString *)fkit_stringByReplacingUnnecessaryWhitespace {
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
                                           range:self.fkit_stringRange
                                    withTemplate:@" "];
}

- (NSString *)fkit_trimmedStringByReplacingUnnecessaryWhitespace {
  return [[self fkit_stringByReplacingUnnecessaryWhitespace] fkit_trimmed];
}

- (BOOL)fkit_isValidEmailAddress {
  NSNumber *isValidWrapper = FKCachedEmailAddressValue(self);
  if (isValidWrapper != nil) {
    return [isValidWrapper boolValue];
  }

  // Regexp from -[NSString(NSEmailAddressString) mf_isLegalEmailAddress] in /System/Library/PrivateFrameworks/MIME.framework
  NSString *emailRegex = @"^[[:alnum:]!#$%&'*+/=?^_`{|}~-]+((\\.?)[[:alnum:]!#$%&'*+/=?^_`{|}~-]+)*@[[:alnum:]-]+(\\.[[:alnum:]-]+)*(\\.[[:alpha:]]+)+$";
  NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];

  BOOL isValid = [emailPredicate evaluateWithObject:self];
  FKCacheEmailAddressValue(self, isValid);
  
  return isValid;
}

- (BOOL)fkit_isValidWebAddress {
  NSNumber *isValidWrapper = FKCachedWebAddressValue(self);
  if (isValidWrapper != nil) {
    return [isValidWrapper boolValue];
  }

  NSString *urlRegex = @"((http|ftp|https):\\/\\/)?[\\w\\-_]+(\\.[\\w\\-_]+)+([\\w\\-\\.,@?^=%&amp;:/~\\+#]*[\\w\\-\\@?^=%&amp;/~\\+#])?";
  NSPredicate *urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];

  BOOL isValid = [urlPredicate evaluateWithObject:[self lowercaseString]];
  FKCacheWebAddressValue(self, isValid);

  return isValid;
}

- (NSString *)fkit_firstLetter {
  if (self.length <= 1)
    return self;
  return [self substringToIndex:1];
}

- (NSString *)fkit_sanitizedPhoneNumber {
  NSCharacterSet *validCharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890-+"];
  NSString *phoneNumber = [self stringByReplacingOccurrencesOfString:@"(0)" withString:@""];

  return [[phoneNumber componentsSeparatedByCharactersInSet:[validCharacters invertedSet]] componentsJoinedByString:@""];
}


@end
