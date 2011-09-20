// Part of FoundationKit http://foundationk.it
//
// Derived from Jerry Jones' Blog Post about NSNumber in Collections and the performance problems
// http://www.ultrajoke.net/2011/08/integers-in-your-collections-nsnumbers-not-my-friend/

#import <Foundation/Foundation.h>

#define kFKMutableIntArrayNoValue   NSIntegerMin


@interface FKMutableIntArray : NSObject

@property (nonatomic, readonly) NSUInteger count;

- (void)addInt:(NSInteger)value;

- (NSInteger)intAtIndex:(NSUInteger)index;
- (NSInteger)firstInt;
- (NSInteger)lastInt;

// TODO: add more functions supported by CFMutableArray

@end
