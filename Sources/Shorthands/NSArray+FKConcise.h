// Part of FoundationKit http://foundationk.it
//
// Derived from Peter Jihoon Kim's MIT-licensed ConciseKit: https://github.com/petejkim/ConciseKit

#define $array(...)   [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define $marray(...)  [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]


@interface NSArray (FKConcise)

@property (nonatomic, readonly, getter = isEmpty) BOOL empty;

- (id)firstObject;
- (id)firstObjectMatchingPredicate:(NSPredicate *)predicate;

- (id)objectOrNilAtIndex:(NSUInteger)index;

- (NSArray *)arrayWithUniqueMembers;

@end