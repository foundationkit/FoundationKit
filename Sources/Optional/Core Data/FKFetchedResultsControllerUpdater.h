// Part of FoundationKit http://foundationk.it
//
// Derived from MrRooni's Gist: https://gist.github.com/MrRooni/4988922


#import <Foundation/Foundation.h>


@interface FKFetchedResultsControllerUpdater : NSObject

@property (nonatomic, assign) NSUInteger maxNumberOfAnimatedChanges; // defaults to 50

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
