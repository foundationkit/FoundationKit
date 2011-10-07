// Part of FoundationKit http://foundationk.it

#import <CoreData/CoreData.h>

@interface NSFetchedResultsController (FKAdditions)

/**
 Returns the number of rows in the given section
 
 @param section the section we want to know the number of rows of.
 @return the number of rows in the given section.
 */
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

@end
