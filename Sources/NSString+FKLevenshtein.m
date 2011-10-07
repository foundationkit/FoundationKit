#import "NSString+FKLevenshtein.h"

FKLoadCategory(NSStringFKLevenshtein);

@implementation NSString (FKLevenshtein)

// TODO: slow algorithm, here is room for improvement
- (NSInteger)levenshteinDistanceToString:(NSString *)string {
  NSInteger selfLength = self.length + 1;
  NSInteger stringLength = string.length + 1;
  NSInteger finalDistance = 0;
  NSInteger **distance = (NSInteger **)malloc(selfLength * sizeof(NSInteger *));
  
  for (NSInteger i=0;i<selfLength;i++) {
    distance[i] = (NSInteger *)malloc(stringLength * sizeof(NSInteger));
    // the distance of any first string to an empty second string
    distance[i][0] = i;
  }
  
  for (NSInteger i=0;i<stringLength;i++) {
    // the distance of any second string to an empty first string
    distance[0][i] = i;
  }
  
  for (NSInteger j=1;j<stringLength;j++) {
    for (NSInteger i=1;i<selfLength;i++) {
      // no operation needed?
      if ([self characterAtIndex:i-1] == [string characterAtIndex:j-1]) {
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
  
  finalDistance = distance[self.length][string.length];
  
  for (NSInteger i=0;i<self.length+1;i++) {
    free(distance[i]);
  }
  
  free(distance);
  
  return finalDistance;
}

@end
