// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (FKAdditions)

- (void)replaceAttribute:(NSString *)attributeName
           matchingValue:(id)valueToReplace
               withValue:(id)newValue
                 inRange:(NSRange)range;

@end
