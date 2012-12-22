#import "NSArray+FKDiff.h"


@implementation FKDiffResult
// nothing to see here ;)
@end


@implementation NSArray (FKDiff)

// Bottom-Up Iterative LCS algorithm from http://www.ics.uci.edu/~eppstein/161/960229.html
- (FKDiffResult *)diffWithArray:(NSArray *)newArray {
  int lengthArray[self.count + 1][newArray.count + 1];

  for (int selfIndex = self.count; selfIndex >= 0; selfIndex--) {
    for (int newIndex = newArray.count; newIndex >= 0; newIndex--) {
      if (selfIndex == self.count || newIndex == newArray.count) {
        lengthArray[selfIndex][newIndex] = 0;
      } else if ([[self objectAtIndex:selfIndex] isEqual:[newArray objectAtIndex:newIndex]]) {
        lengthArray[selfIndex][newIndex] = 1 + lengthArray[selfIndex + 1][newIndex + 1];
      } else {
        lengthArray[selfIndex][newIndex] = MAX(lengthArray[selfIndex + 1][newIndex], lengthArray[selfIndex][newIndex + 1]);
      }
    }
  }

  NSMutableArray *lcsArray = [NSMutableArray array];
  NSMutableArray *combinedArray = [NSMutableArray array];
  NSMutableIndexSet *deletedIndexes = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *insertedIndexes = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *combinedDeletedIndexes = [NSMutableIndexSet indexSet];
  NSMutableIndexSet *combinedInsertedIndexes = [NSMutableIndexSet indexSet];

  NSUInteger selfIndex = 0;
  NSUInteger newIndex = 0;
  NSUInteger combinedIndex = 0;

  while (selfIndex < self.count && newIndex < newArray.count) {
    if ([[self objectAtIndex:selfIndex] isEqual:[newArray objectAtIndex:newIndex]]) {
      [lcsArray addObject:[self objectAtIndex:selfIndex]];
      [combinedArray addObject:[self objectAtIndex:selfIndex]];

      selfIndex++;
      newIndex++;
      combinedIndex++;
    }

    else if (lengthArray[selfIndex + 1][newIndex] >= lengthArray[selfIndex][newIndex + 1]) {
      [combinedArray addObject:[self objectAtIndex:selfIndex]];
      [deletedIndexes addIndex:selfIndex];
      [combinedDeletedIndexes addIndex:combinedIndex];

      selfIndex++;
      combinedIndex++;
    }

    else {
      [combinedArray addObject:[newArray objectAtIndex:newIndex]];
      [insertedIndexes addIndex:newIndex];
      [combinedInsertedIndexes addIndex:combinedIndex];

      newIndex++;
      combinedIndex++;
    }
  }

  FKDiffResult *result = [FKDiffResult new];

  result.oldArray = self;
  result.newArray = newArray;
  result.lcsArray = lcsArray;
  result.combinedArray = combinedArray;
  result.deletedIndexes = deletedIndexes;
  result.insertedIndexes = insertedIndexes;
  result.combinedDeletedIndexes = combinedDeletedIndexes;
  result.combinedInsertedIndexes = combinedInsertedIndexes;
  
  return result;
}

@end
