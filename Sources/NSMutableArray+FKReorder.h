// Part of FoundationKit http://foundationk.it
//
// Derived from iCab-Blogpost: http://www.icab.de/blog/2009/11/15/moving-objects-within-an-nsmutablearray/

#import <Foundation/Foundation.h>


@interface NSMutableArray (FKReorder)

/**
 This method moves the object at index fromIndex to toIndex. 
 If toIndex is greater or equal the number of objects contained in the array,
 the object is appended to the end of the array.
 
 @param fromIndex the index of the object to move
 @param toIndex the index where the object gets inserted
 */
- (void)fkit_moveObjectAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

@end
