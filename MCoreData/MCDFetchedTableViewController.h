//
//  MCDFetchedResultsTableViewController.h
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDObjectViewer.h>
#import <MCoreData/MCDTableViewCell.h>

NS_ASSUME_NONNULL_BEGIN

//@class MCDObjectTableViewCell;

// default cell reuse identifier is Cell, so in storyboard set the table view to this or change it using the property.
// perform fetch is done in view will appear
// <ResultType : id<NSFetchRequestResult>>
@interface MCDFetchedTableViewController<ResultType : NSManagedObject<MCDTableViewCellObject> *> : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, nullable) NSFetchedResultsController<ResultType> *fetchedResultsController;

@property (strong, nonatomic) ResultType selectedObject;

@property (nonatomic, assign, readonly) BOOL shouldAlwaysHaveSelectedObject;

@property (nonatomic, assign) BOOL isMovingOrDeletingObjects;

@property (nonatomic, strong, nullable) NSIndexPath *selectionPathOfDeletedRow;

//@property (nonatomic, strong, nullable) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic, nullable) UIViewController *detailViewController;

- (void)updateSelectionInTableViewAnimated:(BOOL)animated;

- (void)updateSelectionInTableViewAnimated:(BOOL)animated scrollToSelection:(BOOL)scrollToSelection;

- (void)configureDetailViewControllerWithObject:(ResultType)object;

- (UITableViewCell *)cellForObject:(NSManagedObject *)object atIndexPath:(NSIndexPath *)indexPath;

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;

// perform the segue using the objet as the sender.
//- (void)showObject:(nullable NSManagedObject *)object startEditing:(BOOL)startEditing;
- (void)showSelectedObject;

// load the detail controller and perform its segue
//- (void)showDetailObjectForObject:(NSManagedObject *)object;

- (BOOL)isFetchedResultsControllerCreated;

//- (void)showDetailObject:(id)viewedObject;

//- (void)createFetchedResultsController;

// displays a blank view with this message if there are no rows in any section, set to nil to not use this feature.
//@property (copy, nonatomic, nullable) NSString *messageWhenNoRows;

//- (void)scrollToObject:(ResultType)object;

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

//- (void)didSelectObject:(ResultType)object;

// override to translate from the table to the fetch controller, return nil if it's a table only index.
//- (nullable NSIndexPath *)fetchedResultsControllerIndexPathFromTableViewIndexPath:(NSIndexPath *)indexPath;

// override
//- (NSIndexPath *)tableIndexPathFromFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath;

@end

@interface UIViewController (AAPLPhotoContents)

- (NSManagedObject *)mcd_detailObject;
//- (BOOL)mcd_viewedObjectContainsDetailObject:(NSManagedObject *)object;
- (nullable NSManagedObject *)mcd_currentVisibleDetailObjectWithSender:(id)sender;
// change to pushed object.
//- (nullable NSManagedObject *)mcd_currentVisibleObjectWithSender:(id)sender;

//@property (strong, nonatomic, nullable, setter=mcd_setDetailObject:) NSManagedObject *mcd_detailObject;

@end

@interface UIViewController (AAPLViewControllerShowing)

// Returns whether calling showViewController:sender: would cause a navigation "push" to occur
- (BOOL)mcd_willShowingViewControllerPushWithSender:(id)sender;

// Returns whether calling showDetailViewController:sender: would cause a navigation "push" to occur
- (BOOL)mcd_willShowingDetailViewControllerPushWithSender:(id)sender;

@end


NS_ASSUME_NONNULL_END
