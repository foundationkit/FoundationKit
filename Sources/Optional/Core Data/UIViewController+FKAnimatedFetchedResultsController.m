#import "UIViewController+FKAnimatedFetchedResultsController.h"


@implementation UIViewController (FKAnimatedFetchedResultsController)

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSFetchedResultsController Animated Update
////////////////////////////////////////////////////////////////////////

- (void)handleController:(NSFetchedResultsController *)controller willChangeContentForTableView:(UITableView *)tableView {
	[tableView beginUpdates];
}

- (void)handleController:(NSFetchedResultsController *)controller didChangeContentForTableView:(UITableView *)tableView {
	[tableView endUpdates];
}

- (void)handleController:(NSFetchedResultsController *)controller
         didChangeObject:(id)anObject
             atIndexPath:(NSIndexPath *)indexPath
           forChangeType:(NSFetchedResultsChangeType)type
            newIndexPath:(NSIndexPath *)newIndexPath
               tableView:(UITableView *)tableView {
  
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)handleController:(NSFetchedResultsController *)controller
        didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                 atIndex:(NSUInteger)sectionIndex
           forChangeType:(NSFetchedResultsChangeType)type
               tableView:(UITableView *)tableView {
  UITableView *tableView = self.tableView;

  switch(type) {
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeUpdate:
      [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

@end