#import "NSFetchedResultsController+FKAdditions.h"

@implementation NSFetchedResultsController (FKAdditions)

- (NSInteger)numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  if (self.sections.count > 0) {
    numberOfRows = [[self.sections objectAtIndex:section] numberOfObjects];
  }
  
  return numberOfRows;
}

@end
