//
//  InitialViewController.m
//  MCDDemo
//
//  Created by Malcolm Hall on 09/08/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "InitialViewController.h"
#import "MasterViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

//- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
//    if(managedObjectContext == _managedObjectContext){
//        return;
//    }
//    _managedObjectContext = managedObjectContext;
//    NSAssert(managedObjectContext, @"InitialViewController requries a context");

- (void)createFetchedResultsController{
    //NSManagedObjectContext * context = [NSManagedObjectContext.alloc initWithConcurrencyType:NSMainQueueConcurrencyType];
    //context.parentContext = self.persistentContainer.viewContext;
    //context.mcd_automaticallyMergesChangesFromParent = YES;
    
    NSFetchRequest *fetchRequest = Venue.fetchRequest;
    // NSDictionary *d = self.fetchItem;
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sectionKey = %@", d[@"sectionKey"]];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionKey" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];
    //    [fetchRequest setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    [fetchRequest setSortDescriptors:@[sortDescriptor2]];
    fetchRequest.propertiesToFetch = @[@"timestamp"];
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *fetchedResultsController = [NSFetchedResultsController.alloc initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Initial"]; // @"sectionKey"
    //aFetchedResultsController.delegate = self;
    // self.fetchedResultsController = aFetchedResultsController;
    
    //    NSError *error = nil;
    //    if (![fetchedResultsController performFetch:&error]) {
    //        // Replace this implementation with code to handle the error appropriately.
    //        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    //        abort();
    //    }
    self.fetchedResultsController = fetchedResultsController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //    if(!self.malc){
    //        return;
    //    }
    //- (NSFetchedResultsController *)fetchedResultsController
    //{
    //    if (_fetchedResultsController != nil) {
    //        return _fetchedResultsController;
    //    }

//    UIBarButtonItem *addButton = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //return _fetchedResultsController;
    
   // [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    [self performSelector:@selector(malc) withObject:nil afterDelay:5];
}

- (void)malc{

}

- (IBAction)insertNewObject:(id)sender {
   // NSManagedObjectContext *context = self.persistentContainer.newBackgroundContext;
    NSManagedObjectContext *context = self.managedObjectContext;
    NSEntityDescription *entity = self.fetchedResultsController.fetchRequest.entity; // fetchedTableData
    if(!entity){
        return;
    }
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [object setValue:[NSDate date] forKey:@"timestamp"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showDetail"]) {
//        Event *event = (Event *)sender;
//        DetailViewController *controller = (DetailViewController *)[segue.destinationViewController topViewController];
//        controller.viewedObject = event;
//    }
//    else
    if ([[segue identifier] isEqualToString:@"show"]) {
        //UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        MasterViewController *controller = (MasterViewController *)segue.destinationViewController;
        controller.managedObjectContext = self.managedObjectContext;
        controller.masterItem = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //self.shownViewController = controller;
        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        //self.shownViewController = controller;
    }
}

//- (BOOL)shouldShowDetailForIndexPath:(NSIndexPath *)indexPath{
//    return NO;
//}

- (BOOL)showsDetail{
    return NO;
}

//- (void)showObject:(nullable NSManagedObject *)object startEditing:(BOOL)startEditing{
- (void)showSelectedObject{
    //Venue *venue = (Venue *)object;
    //MasterViewController *master = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    //Event *event = venue.events.allObjects.firstObject;
    [self performSegueWithIdentifier:@"show" sender:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        //Event *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObjectContext *context = self.managedObjectContext;
        [context deleteObject:object];
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
}

//- (BOOL)mcd_viewedObjectContainsDetailObject:(NSManagedObject *)object{
- (NSIndexPath *)indexPathContainingDetailObject:(NSManagedObject *)object{
    NSIndexPath *indexPath;
    if([object isKindOfClass:Event.class]){
        Event *event = (Event *)object;
        Venue *venue = event.venue;
        indexPath = [self.fetchedResultsController indexPathForObject:venue];
    }
    return indexPath;
}


@end
