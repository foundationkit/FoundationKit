#import "FKFetchedResultsControllerUpdater.h"


@interface FKFetchedResultsControllerUpdater ()

// Declare some collection properties to hold the various updates we might get from the NSFetchedResultsControllerDelegate
@property (nonatomic, strong) NSMutableIndexSet *deletedSectionIndexes;
@property (nonatomic, strong) NSMutableIndexSet *insertedSectionIndexes;
@property (nonatomic, strong) NSMutableArray *deletedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *insertedRowIndexPaths;
@property (nonatomic, strong) NSMutableArray *updatedRowIndexPaths;

@end


@implementation FKFetchedResultsControllerUpdater

- (id)init {
  if ((self = [super init])) {
    _maxNumberOfAnimatedChanges = 50;
  }

  return self;
}

- (void)handleController:(NSFetchedResultsController *)controller willChangeContentForTableView:(UITableView *)tableView {
  // do nothing
}

- (void)handleController:(NSFetchedResultsController *)controller didChangeContentForTableView:(UITableView *)tableView {
  NSInteger totalChanges = ([self.deletedSectionIndexes count] + [self.insertedSectionIndexes count] +
                            [self.deletedRowIndexPaths count] + [self.insertedRowIndexPaths count] + [self.updatedRowIndexPaths count]);

  // don't animate if there are too many changes
  if (totalChanges > self.maxNumberOfAnimatedChanges) {
    [tableView reloadData];
    return;
  }

  [tableView beginUpdates];

  [tableView deleteSections:self.deletedSectionIndexes withRowAnimation:UITableViewRowAnimationAutomatic];
  [tableView insertSections:self.insertedSectionIndexes withRowAnimation:UITableViewRowAnimationAutomatic];

  [tableView deleteRowsAtIndexPaths:self.deletedRowIndexPaths withRowAnimation:UITableViewRowAnimationLeft];
  [tableView insertRowsAtIndexPaths:self.insertedRowIndexPaths withRowAnimation:UITableViewRowAnimationRight];
  [tableView reloadRowsAtIndexPaths:self.updatedRowIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];

  [tableView endUpdates];

  // nil out the collections so their ready for their next use.
  self.insertedSectionIndexes = nil;
  self.deletedSectionIndexes = nil;
  self.deletedRowIndexPaths = nil;
  self.insertedRowIndexPaths = nil;
  self.updatedRowIndexPaths = nil;
}

- (void)handleController:(NSFetchedResultsController *)controller
         didChangeObject:(id)anObject
             atIndexPath:(NSIndexPath *)indexPath
           forChangeType:(NSFetchedResultsChangeType)type
            newIndexPath:(NSIndexPath *)newIndexPath
               tableView:(UITableView *)tableView {
  if (type == NSFetchedResultsChangeInsert) {
    if ([self.insertedSectionIndexes containsIndex:newIndexPath.section]) {
      // If we've already been told that we're adding a section for this inserted row we skip it since it will handled by the section insertion.
      return;
    }

    [self.insertedRowIndexPaths addObject:newIndexPath];
  } else if (type == NSFetchedResultsChangeDelete) {
    if ([self.deletedSectionIndexes containsIndex:indexPath.section]) {
      // If we've already been told that we're deleting a section for this deleted row we skip it since it will handled by the section deletion.
      return;
    }

    [self.deletedRowIndexPaths addObject:indexPath];
  } else if (type == NSFetchedResultsChangeMove) {
    if ([self.insertedSectionIndexes containsIndex:newIndexPath.section] == NO) {
      [self.insertedRowIndexPaths addObject:newIndexPath];
    }

    if ([self.deletedSectionIndexes containsIndex:indexPath.section] == NO) {
      [self.deletedRowIndexPaths addObject:indexPath];
    }
  } else if (type == NSFetchedResultsChangeUpdate) {
    [self.updatedRowIndexPaths addObject:indexPath];
  }
}

- (void)handleController:(NSFetchedResultsController *)controller
        didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                 atIndex:(NSUInteger)sectionIndex
           forChangeType:(NSFetchedResultsChangeType)type
               tableView:(UITableView *)tableView {
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.insertedSectionIndexes addIndex:sectionIndex];
      break;
    case NSFetchedResultsChangeDelete:
      [self.deletedSectionIndexes addIndex:sectionIndex];
      break;
    default:
      ; // Shouldn't have a default
      break;
  }
}

////////////////////////////////////////////////////////////////////////
#pragma mark - Private
////////////////////////////////////////////////////////////////////////

- (NSMutableIndexSet *)deletedSectionIndexes {
  if (_deletedSectionIndexes == nil) {
    _deletedSectionIndexes = [[NSMutableIndexSet alloc] init];
  }

  return _deletedSectionIndexes;
}

- (NSMutableIndexSet *)insertedSectionIndexes {
  if (_insertedSectionIndexes == nil) {
    _insertedSectionIndexes = [[NSMutableIndexSet alloc] init];
  }

  return _insertedSectionIndexes;
}

- (NSMutableArray *)deletedRowIndexPaths {
  if (_deletedRowIndexPaths == nil) {
    _deletedRowIndexPaths = [[NSMutableArray alloc] init];
  }

  return _deletedRowIndexPaths;
}

- (NSMutableArray *)insertedRowIndexPaths {
  if (_insertedRowIndexPaths == nil) {
    _insertedRowIndexPaths = [[NSMutableArray alloc] init];
  }

  return _insertedRowIndexPaths;
}

- (NSMutableArray *)updatedRowIndexPaths {
  if (_updatedRowIndexPaths == nil) {
    _updatedRowIndexPaths = [[NSMutableArray alloc] init];
  }

  return _updatedRowIndexPaths;
}

@end
