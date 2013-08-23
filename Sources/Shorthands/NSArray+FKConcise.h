// Part of FoundationKit http://foundationk.it
//
// Derived from Peter Jihoon Kim's MIT-licensed ConciseKit: https://github.com/petejkim/ConciseKit


@interface NSArray (FKConcise)

- (id)fkit_firstObjectMatchingPredicate:(NSPredicate *)predicate;
- (id)fkit_objectOrNilAtIndex:(NSUInteger)index;

- (NSArray *)fkit_arrayWithUniqueMembers;

@end