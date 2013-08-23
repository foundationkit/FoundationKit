// Part of FoundationKit http://foundationk.it

#import "NSNumber+FKConcise.h"

FKLoadCategory(NSNumberFKConcise);

static NSNumberFormatter *numberFormatter = nil;

@implementation NSNumber (FKConcise)

+ (NSNumber *)fkit_numberWithString:(NSString *)string {
  static dispatch_once_t onceToken;
  
  dispatch_once(&onceToken, ^{
    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];    
  });
  
  if (string) {
    @try {
      return [numberFormatter numberFromString:string];
    }
    @catch (NSException * e) {
      FKLogDebug(@"NSNumberFormatter exception! parsing: %@", string);
    }
  }
  
  return nil;
}

@end
