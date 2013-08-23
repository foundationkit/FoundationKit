// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (FKAdditions)

- (void)fkit_replaceAttribute:(NSString *)attributeName
                matchingValue:(id)valueToReplace
                    withValue:(id)newValue
                      inRange:(NSRange)range;

@end
