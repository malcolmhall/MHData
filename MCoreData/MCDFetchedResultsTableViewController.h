//
//  MCDFetchedResultsTableViewController.h
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

// default cell reuse identifier is Cell, so in storyboard set the table view to this or change it using the property.
// perform fetch is done in view will appear
@interface MCDFetchedResultsTableViewController<ResultType:id<NSFetchRequestResult>> : UITableViewController <NSFetchedResultsControllerDelegate>

// Set this to make it work, and the delegate is automatically set to this view controller.
// setting reloads the table but does not fetch.
@property (strong, nonatomic, nullable) NSFetchedResultsController<ResultType> *fetchedResultsController;

// performs fetch and reloads the table, useful after changing the sort descriptor on the fetch request.
- (void)fetchAndReloadData;

// displays a blank view with this message if there are no rows in any section, set to nil to not use this feature.
//@property (copy, nonatomic, nullable) NSString *messageWhenNoRows;

// create or dequeue a cell and set the object on it if necesseary.
- (UITableViewCell *)cellForObject:(id)object;

- (BOOL)canEditObject:(id)object;

- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(ResultType)object;

- (BOOL)shouldHighlightObject:(id)object;

//- (void)tearDownFetchedResultsController;

/*
- (void)viewDidLoad{
    [super viewDidLoad];
     NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([StoreApp class])];
     // Set the batch size to a suitable number.
     [fetchRequest setFetchBatchSize:20];
     fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name != nil"];
     // Edit the sort key as appropriate.
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
     fetchRequest.sortDescriptors = @[sortDescriptor];
     // Edit the section name key path and cache name if appropriate.
     // nil for section name key path means "no sections".
     self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[Model sharedModel].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
 }
*/

// the default implementation is to delete the object from the context and save it, and abort if it fails. Override for a different behavior.
// returns NO and sets error if fails to save. Doesn't any more.
//- (void)deleteResultObject:(NSManagedObject *)resultObject;

- (void)didSelectObject:(ResultType)object;

- (void)deselectObject:(ResultType)object animated:(BOOL)animated;

// transaltes from table view index to fetch index and gets the object.
- (ResultType)objectAtTableViewIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)tableViewIndexPathForObject:(ResultType)object;

// default implementation gets the section info name for the object.
- (NSString *)sectionHeaderTitleForObject:(ResultType)object;

// override to translate from the table to the fetch controller, return nil if it's a table only index.
- (nullable NSIndexPath *)fetchedResultsControllerIndexPathFromTableViewIndexPath:(NSIndexPath *)indexPath;

// override
- (NSIndexPath *)tableViewIndexPathFromFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
