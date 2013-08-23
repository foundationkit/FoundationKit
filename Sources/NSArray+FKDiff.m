#import "NSArray+FKDiff.h"


@implementation FKDiffResult

- (NSString *)description {
  return [NSString stringWithFormat:@"Deleted indexes:\n%@\nInserted indexes:\n%@", self.deletedIndexes, self.insertedIndexes];
}

@end


@implementation NSArray (FKDiff)

// Bottom-Up Iterative LCS algorithm from http://www.ics.uci.edu/~eppstein/161/960229.html
-(FKDiffResult *)fkit_diffWithArray:(NSArray *)newArray {
  NSUInteger lengthArray[self.count + 1][newArray.count + 1];

  for (NSInteger selfIndex = self.count; selfIndex >= 0; selfIndex--) {
    for (NSInteger newIndex = newArray.count; newIndex >= 0; newIndex--) {
      if (selfIndex == (NSInteger)self.count || newIndex == (NSInteger)newArray.count) {
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
  NSMutableArray *deletedObjects = [NSMutableArray array];
  NSMutableArray *insertedObjects = [NSMutableArray array];
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
      [deletedObjects addObject:[self objectAtIndex:selfIndex]];
      [deletedIndexes addIndex:selfIndex];
      [combinedDeletedIndexes addIndex:combinedIndex];

      selfIndex++;
      combinedIndex++;
    }

    else {
      [combinedArray addObject:[newArray objectAtIndex:newIndex]];
      [insertedObjects addObject:[newArray objectAtIndex:newIndex]];
      [insertedIndexes addIndex:newIndex];
      [combinedInsertedIndexes addIndex:combinedIndex];

      newIndex++;
      combinedIndex++;
    }
  }

  while (selfIndex < self.count) {
    [combinedArray addObject:[self objectAtIndex:selfIndex]];
    [deletedObjects addObject:[self objectAtIndex:selfIndex]];
    [deletedIndexes addIndex:selfIndex];
    [combinedDeletedIndexes addIndex:combinedIndex];

    selfIndex++;
    combinedIndex++;
  }

  while (newIndex < newArray.count) {
    [combinedArray addObject:[newArray objectAtIndex:newIndex]];
    [insertedObjects addObject:[newArray objectAtIndex:newIndex]];
    [insertedIndexes addIndex:newIndex];
    [combinedInsertedIndexes addIndex:combinedIndex];

    newIndex++;
    combinedIndex++;
  }

  FKDiffResult *result = [FKDiffResult new];

  result.oldArray = self;
  result.newArray = newArray;
  result.lcsArray = lcsArray;
  result.combinedArray = combinedArray;
  result.deletedObjects = deletedObjects;
  result.insertedObjects = insertedObjects;
  result.deletedIndexes = deletedIndexes;
  result.insertedIndexes = insertedIndexes;
  result.combinedDeletedIndexes = combinedDeletedIndexes;
  result.combinedInsertedIndexes = combinedInsertedIndexes;

  return result;
}


@end
