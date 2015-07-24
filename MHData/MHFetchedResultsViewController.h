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

-(BOOL)canEditObject:(NSManagedObject*)managedObject;

// when set the delegate is automatically set to this view controller.
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
/*
-(void)viewDidLoad{
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

// the default implementation is to delete the object from the context and save it. Override for a different behavior.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

@end
