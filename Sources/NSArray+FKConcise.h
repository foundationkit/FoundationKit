// Part of FoundationKit http://foundationk.it
//
// Derived from Peter Jihoon Kim's MIT-licensed ConciseKit: https://github.com/petejkim/ConciseKit

#define $arr(...)   [NSArray arrayWithObjects:__VA_ARGS__, nil]
#define $marr(...)  [NSMutableArray arrayWithObjects:__VA_ARGS__, nil]


@interface NSArray (FKConcise)

- (id)firstObject;
- (id)firstObjectMatchingPredicate:(NSPredicate *)predicate;

- (id)objectOrNilAtIndex:(NSUInteger)index;

- (NSArray *)arrayWithUniqueMembers;

@end