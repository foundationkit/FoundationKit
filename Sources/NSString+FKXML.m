#import "NSString+FKXML.h"
#import "FKInternal.h"

@implementation NSString (FKXML)

- (NSString *)stringByDecodingXMLEntities {
  NSUInteger myLength = [self length];
  NSUInteger ampIndex = [self rangeOfString:@"&" options:NSLiteralSearch].location;
  
  // Short-circuit if there are no ampersands.
  if (ampIndex == NSNotFound) {
    return self;
  }
  // Make result string with some extra capacity.
  NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
  
  // First iteration doesn't need to scan to & since we did that already, 
  // but for code simplicity's sake we'll do it again with the scanner.
  NSScanner *scanner = [NSScanner scannerWithString:self];
  scanner.caseSensitive = YES;
  [scanner setCharactersToBeSkipped:nil];
  NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
  
  do {
    // Scan up to the next entity or the end of the string.
    NSString *nonEntityString;
    
    if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
      [result appendString:nonEntityString];
    }
    if ([scanner isAtEnd]) {
      break;
    }
    
    // Scan either a HTML or numeric character entity reference.
    if ([scanner scanString:@"&amp;" intoString:NULL]) {
      [result appendString:@"&"];
    } else if ([scanner scanString:@"&apos;" intoString:NULL]) {
      [result appendString:@"'"];
    } else if ([scanner scanString:@"&quot;" intoString:NULL]) {
      [result appendString:@"\""];
    } else if ([scanner scanString:@"&lt;" intoString:NULL]) {
      [result appendString:@"<"];
    } else if ([scanner scanString:@"&gt;" intoString:NULL]) {
      [result appendString:@">"];
    } else if ([scanner scanString:@"&Ouml;" intoString:NULL]) {
      [result appendString:@"Ö"];
    } else if ([scanner scanString:@"&Uuml;" intoString:NULL]) {
      [result appendString:@"Ü"];
    } else if ([scanner scanString:@"&Auml;" intoString:NULL]) {
      [result appendString:@"Ä"];
    } else if ([scanner scanString:@"&ouml;" intoString:NULL]) {
      [result appendString:@"ö"];
    } else if ([scanner scanString:@"&uuml;" intoString:NULL]) {
      [result appendString:@"ü"];
    } else if ([scanner scanString:@"&auml;" intoString:NULL]) {
      [result appendString:@"ä"];
    } else if ([scanner scanString:@"&szlig;" intoString:NULL]) { 
      [result appendString:@"ß"];
    } else if ([scanner scanString:@"&nbsp;" intoString:NULL]) {  
      [result appendString:@" "];
    } else if ([scanner scanString:@"&#" intoString:NULL]) {
      BOOL gotNumber;
      unsigned charCode;
      NSString *xForHex = @"";
      
      // Is it hex or decimal?
      if ([scanner scanString:@"x" intoString:&xForHex]) {
        gotNumber = [scanner scanHexInt:&charCode];
      } else {
        gotNumber = [scanner scanInt:(int*)&charCode];
      }
      
      if (gotNumber) {
        [result appendFormat:@"%u", charCode];
        [scanner scanString:@";" intoString:NULL];
      } else {
        NSString *unknownEntity = @"";
        
        [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
        [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
        
        FKLogDebug(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
      }
    } else {
      NSString *amp;
      
      [scanner scanString:@"&" intoString:&amp];      //an isolated & symbol
      [result appendString:amp];
    }
  } while (![scanner isAtEnd]);
  
  return result;
}

@end
