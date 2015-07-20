//
//  MHFetchedResultsViewController.h
//  MHData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

// default cell reuse identifier is Cell, so in storyboard set the table view to this or change it using the property.

@interface MHFetchedResultsViewController : UITableViewController<NSFetchedResultsControllerDelegate>

// Defaults to "Cell"
@property (copy, nonatomic) NSString* cellReuseIdentifier;

@property (copy, nonatomic) NSString* messageWhenNoData;

// subclass and override 2 methods
- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;

/*
 - (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object;
 {
    StoreApp* storeApp  = (StoreApp*) object;
    cell.textLabel.text = storeApp.name;
    cell.imageView.image = storeApp.icon;
 }
*/

// when set the delegate is automatically set to this view controller.
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
/*
-(void)awakeFromNib{
    [super awakeFromNib];
     NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([StoreApp class])];
     // Set the batch size to a suitable number.
     [fetchRequest setFetchBatchSize:20];
     fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name != nil"];
     // Edit the sort key as appropriate.
     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(caseInsensitiveCompare:)];
     NSArray *sortDescriptors = @[sortDescriptor];
     [fetchRequest setSortDescriptors:sortDescriptors];
     // Edit the section name key path and cache name if appropriate.
     // nil for section name key path means "no sections".
     self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[Model sharedModel].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
     
     NSError *error = nil;
     if (![self.fetchedResultsController performFetch:&error]) {
     // Replace this implementation with code to handle the error appropriately.
     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
     abort();
     }
 }
*/

// the default implementation is to delete the object from the context and save it. Override for a different behavior.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
