// Part of FoundationKit http://foundationk.it

#import <Foundation/Foundation.h>

@interface NSMutableArray (FKConcise)

- (void)moveObjectAtIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex;
- (void)shuffle;

- (void)addObjectIfNotNil:(id)object;

@end
