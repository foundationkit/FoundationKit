#import "NSMutableAttributedString+FKAdditions.h"


@implementation NSMutableAttributedString (FKAdditions)

- (void)replaceAttribute:(NSString *)attributeName
           matchingValue:(id)valueToReplace
               withValue:(id)newValue
                 inRange:(NSRange)range {
  [self enumerateAttribute:attributeName inRange:range options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(id value, NSRange rangeOfMatch, BOOL *stop) {
    if ([value isEqual:valueToReplace]) {
      [self addAttribute:attributeName value:newValue range:rangeOfMatch];
    }
  }];
}

@end
