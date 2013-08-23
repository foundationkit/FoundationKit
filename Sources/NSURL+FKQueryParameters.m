#import "NSURL+FKQueryParameters.h"
#import "NSString+FKAdditions.h"


@implementation NSURL (FKQueryParameters)

+ (NSURL *)fkit_URLWithString:(NSString *)string queryValuesForKeys:(NSString *)value, ... {
  if (value == nil) {
    return [NSURL URLWithString:string];
  }

  NSMutableString *queryString = [NSMutableString string];
  NSString *argument = nil;
  NSUInteger argumentCount = 0;

  va_list argumentList;
  va_start(argumentList, value);

  while ((argument = va_arg(argumentList, NSString *))) {
    argumentCount++;

    if (argumentCount % 2 == 0) {
      value = argument;
    } else {
      NSString *separator = @"&";
      if (argumentCount == 1) {
        separator = @"?";
      }

      [queryString appendFormat:@"%@%@=%@", separator, argument, [value fkit_URLEncodedString]];
    }
  }

  va_end(argumentList);

  NSAssert(argumentCount % 2 != 0, @"Uneven amount of query keys and values.");

  return [NSURL URLWithString:[string stringByAppendingString:queryString]];
}

@end
