#import "NSString+FKAdditions.h"

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

@end
