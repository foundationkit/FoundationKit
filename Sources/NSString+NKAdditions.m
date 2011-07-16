#import "NSString+NKAdditions.h"

@implementation NSString (NKAdditions)

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
  return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                   (__bridge CFStringRef)self,
                                                                   NULL,
                                                                   CFSTR("?=&+"),
                                                                   kCFStringEncodingUTF8));
}

- (NSString *)URLEncodedStringEscapingAllCharacters {
  return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                   (__bridge CFStringRef)self,
                                                                   NULL,
                                                                   CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                   kCFStringEncodingUTF8));
}

@end
