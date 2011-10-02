// Part of FoundationKit http://foundationk.it
//
// Derived from Jerry Jones' Blog Post about NSNumber in Collections and the performance problems
// http://www.ultrajoke.net/2011/08/integers-in-your-collections-nsnumbers-not-my-friend/

#import <Foundation/Foundation.h>

#define kFKMutableIntArrayNoValue   NSIntegerMin


/**
 FKMutableIntArray is a simple Wrapper around CFMutableArray which is used to store skalars
 in the array, by defining no callbacks. This is much faster than using an NSMutableArray
 and boxing/unboxing the integers in NSNumber-Objects.
 */
@interface FKMutableIntArray : NSObject

/** The number of ints stored in the array. */
@property (nonatomic, readonly) NSUInteger count;
/** check whether the array is empty */
@property (nonatomic, readonly, getter = isEmpty) BOOL empty;
/** the underlying CFMutableArrayRef */
@property (nonatomic, readonly) CFMutableArrayRef arrayRef;


/**
 Appends a number to the end of the array.
 
 @param number The number to append to the end of the array.
 */
- (void)addNumber:(NSInteger)number;

/**
 Inserts a number at a specific position in the array.
 
 @param number The number to insert in the array.
 @param index The position the number gets inserted before.
 */
- (void)insertNumber:(NSInteger)number atIndex:(NSUInteger)index;

/**
 Removes all numbers from the array. After this operation `isEmpty` returns YES.
 */
- (void)removeAllNumbers;

/**
 Removes a number at at specific position.
 
 @param index The position of the number to remove.
 */
- (void)removeNumberAtIndex:(NSUInteger)index;

/**
 Returns the number at the given index. This method is faster than numberOrNoValueAtIndex but can crash, if the index is out of bounds.
 
 @return The number stored at the index.
 @param index The index of the number to return.
 @see numberOrNoValueAtIndex
 */
- (NSInteger)numberAtIndex:(NSUInteger)index;

/**
 Returns the number at the given index. This method performs a bound-check and is therefore slower than numberAtIndex.
 
 @return The number stored at the index, or `kFKMutableIntArrayNoValue` if the index is greater or equal the number of numbers stored.
 @param index The index of the number to return.
 @see numberAtIndex
 */
- (NSInteger)numberOrNoValueAtIndex:(NSUInteger)index;

/**
 REturns the first number in the array.
 
 @return The first number in the array, or `kFKMutableIntArrayNoValue` if the array is empty.
 */
- (NSInteger)firstNumber;

/**
 Returns the last number in the array.
 
 @return The last number in the array, or `kFKMutableIntArrayNoValue` if the array is empty.
 */
- (NSInteger)lastNumber;

/**
 Returns the index of a given number in the array.
 
 @return The index of the number if it was found, or `NSNotFound` otherwise.
 */
- (NSUInteger)indexOfNumber:(NSInteger)number;

@end
