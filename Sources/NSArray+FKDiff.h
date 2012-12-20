// Part of FoundationKit http://foundationk.it
//
// Derived from Joel Bernstein‘s JBCommon: https://github.com/Bergamot/JBCommon

#import <Foundation/Foundation.h>

@interface FKDiffResult : NSObject

@property (nonatomic, copy) NSArray *oldArray;
@property (nonatomic, copy, getter = theNewArray) NSArray *newArray;
@property (nonatomic, copy) NSArray *lcsArray;
@property (nonatomic, copy) NSArray *combinedArray;

// deletedIndexes and insertedIndexes are the indexes that must be deleted from the oldArray,
// and then inserted to form the newArray. These are useful for tableview animation.
@property (nonatomic, copy) NSIndexSet *deletedIndexes;
@property (nonatomic, copy) NSIndexSet *insertedIndexes;

// combinedDeletedIndexes and combinedInsertedIndexes are indexes to the combinedArray,
// used to display which elements in combinedArray were inserted or deleted.
@property (nonatomic, copy) NSIndexSet *combinedDeletedIndexes;
@property (nonatomic, copy) NSIndexSet *combinedInsertedIndexes;

@end


@interface NSArray (FKDiff)

- (FKDiffResult *)diffWithArray:(NSArray *)newArray;

@end
