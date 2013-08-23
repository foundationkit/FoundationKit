#import "NSString+FKLevenshtein.h"

FKLoadCategory(NSStringFKLevenshtein);

@implementation NSString (FKLevenshtein)

- (NSInteger)fkit_levenshteinDistanceToString:(NSString *)string {
  return [self fkit_levenshteinDistanceToString:string caseSensitive:NO];
}

// TODO: slow algorithm, here is room for improvement
- (NSInteger)fkit_levenshteinDistanceToString:(NSString *)string caseSensitive:(BOOL)caseSensitive {
  NSString *string1 = caseSensitive ? self : [self lowercaseString];
  NSString *string2 = caseSensitive ? string : [string lowercaseString];
  NSInteger string1Length = string1.length + 1;
  NSInteger string2Length = string2.length + 1;
  NSInteger finalDistance = 0;
  NSInteger **distance = (NSInteger **)malloc(string1Length * sizeof(NSInteger *));
  
  for (NSInteger i=0;i<string1Length;i++) {
    distance[i] = (NSInteger *)malloc(string2Length * sizeof(NSInteger));
    // the distance of any first string to an empty second string
    distance[i][0] = i;
  }
  
  for (NSInteger i=0;i<string2Length;i++) {
    // the distance of any second string to an empty first string
    distance[0][i] = i;
  }
  
  for (NSInteger j=1;j<string2Length;j++) {
    for (NSInteger i=1;i<string1Length;i++) {
      // no operation needed?
      if ([string1 characterAtIndex:i-1] == [string2 characterAtIndex:j-1]) {
        distance[i][j] = distance[i-1][j-1];
      }
      
      // operation needed, increase distance
      else {
        NSInteger minDistance = MIN(distance[i-1][j] + 1,   // a deletion
                                    distance[i][j-1] + 1);  // an insertion
        
        minDistance = MIN(minDistance,
                          distance[i-1][j-1] + 1);          // a substitution
        
        distance[i][j] = minDistance;
      }
    }
  }
  
  finalDistance = distance[string1Length-1][string2Length-1];
  
  for (NSInteger i=0;i<string1Length;i++) {
    free(distance[i]);
  }
  
  free(distance);
  
  return finalDistance;
}

@end
