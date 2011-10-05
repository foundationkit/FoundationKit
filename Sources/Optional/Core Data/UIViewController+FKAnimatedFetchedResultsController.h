// Part of FoundationKit http://foundationk.it
// 
// Derived from Book More iPhone 3 Development Chapter 2: The Anatomy of Core Data, Page 29ff

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface UIViewController (FKAnimatedFetchedResultsController)

- (void)handleController:(NSFetchedResultsController *)controller willChangeContentForTableView:(UITableView *)tableView;
- (void)handleController:(NSFetchedResultsController *)controller didChangeContentForTableView:(UITableView *)tableView;

- (void)handleController:(NSFetchedResultsController *)controller
         didChangeObject:(id)anObject
             atIndexPath:(NSIndexPath *)indexPath
           forChangeType:(NSFetchedResultsChangeType)type
            newIndexPath:(NSIndexPath *)newIndexPath
               tableView:(UITableView *)tableView;

- (void)handleController:(NSFetchedResultsController *)controller
        didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
                 atIndex:(NSUInteger)sectionIndex
           forChangeType:(NSFetchedResultsChangeType)type
               tableView:(UITableView *)tableView;

@end
