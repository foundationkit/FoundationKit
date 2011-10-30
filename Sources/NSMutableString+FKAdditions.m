#import "NSMutableString+FKAdditions.h"

@implementation NSMutableString (FKAdditions)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
  return [self replaceOccurrencesOfString:target withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
}

@end
