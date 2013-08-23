#import "NSMutableString+FKAdditions.h"

@implementation NSMutableString (FKAdditions)

- (NSUInteger)fkit_replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement {
  return [self replaceOccurrencesOfString:target withString:replacement options:NSCaseInsensitiveSearch range:NSMakeRange(0, self.length)];
}

@end
