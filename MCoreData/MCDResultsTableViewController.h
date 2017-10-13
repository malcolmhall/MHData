//
//  MCDResultsTableViewController.h
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

@interface MCDResultsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

// Set this to make it work, and the delegate is automatically set to this view controller.
@property (strong, nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;

- (NSFetchedResultsController *)newFetchedResultsController;

- (void)recreateFetchedResultsController;

- (void)recreateFetchedResultsControllerPerformFetch:(BOOL)performFetch;

// the item that affects the fetch, when set the fetch will be recreated and can take into account the new item.
@property (strong, nonatomic) id fetchItem;

@property (strong, nonatomic) NSArray<NSString *> *keyPathsForObservingFetchItem;

- (void)observedChangeOfFetchItemKeyPath:(NSString *)keyPath;

// displays a blank view with this message if there are no rows in any section, set to nil to not use this feature.
@property (copy, nonatomic, null_resettable) NSString *messageWhenNoRows;

// cell style to use when no prototype is found.
@property (assign, nonatomic) UITableViewCellStyle defaultCellStyle;

- (UITableViewCell *)cellForResultObject:(NSManagedObject *)resultObject;

- (BOOL)canEditResultObject:(NSManagedObject *)resultObject;

- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forResultObject:(NSManagedObject *)resultObject;

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
- (void)deleteResultObject:(NSManagedObject *)resultObject;

- (NSManagedObject *)resultObjectAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
