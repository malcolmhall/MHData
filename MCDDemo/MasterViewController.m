//
//  MasterViewController.m
//  MCoreDataDemo
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "EventTableViewCell.h"

@interface MasterViewController ()

@end

@implementation MasterViewController{
    NSArray *_sectionKeys;
}

- (IBAction)teardownButtonTapped:(id)sender{
    self.fetchedResultsController = nil;
}
    
- (IBAction)recreateButtonTapped:(id)sender{
    [self newFetchedResultsController];
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.persistentContainer.viewContext.mcd_automaticallyMergesChangesFromParent = YES;
    //self.messageWhenNoRows = @"Sorry there are no rows";
 //   self.keyPathsForObservingFetchItem = @[@"sectionKey"];
    
    _sectionKeys = @[@"a", @"b", @"c", @"d", @"e"];
    //[self performSelector:@selector(test) withObject:nil afterDelay:2];
    self.tableView.allowsSelectionDuringEditing = YES;
    [self newFetchedResultsController];
    [self performSelector:@selector(malc) withObject:nil afterDelay:2];
}

- (void)malc{
   // [self performSegueWithIdentifier:@"showDetail" sender:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    //NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
   //NSManagedObjectContext * context = self.persistentContainer.newBackgroundContext;
    ///NSManagedObjectContext * context = [NSManagedObjectContext.alloc initWithConcurrencyType:NSMainQueueConcurrencyType];
    //context.parentContext = self.fetchedResultsController.managedObjectContext;
    //context.mcd_automaticallyMergesChangesFromParent = YES;
    //context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    //[context performBlock:^{
    if(!context){
        return;
    }
    NSEntityDescription *entity = self.fetchedResultsController.fetchRequest.entity;
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [object setValue:[NSDate date] forKey:@"timestamp"];
    
    int i = arc4random_uniform(_sectionKeys.count);
    [object setValue:_sectionKeys[i] forKey:@"sectionKey"];
    
    // Save the context.
    NSError *error = nil;
    if (![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return [[self.fetchedResultsController sections] count];
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//    return [sectionInfo numberOfObjects];
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    NSManagedObject *object = [self objectAtIndexPath:indexPath];
//    [self configureCell:cell withObject:object];
//    return cell;
//}

//- (UITableViewCell *)cellForResultObject:(NSManagedObject *)resultObject{
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    return cell;
//}

- (UITableViewCell *)cellForObject:(Event *)event{
    EventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Event"];
    cell.fetchedObject = event;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!tableView.isEditing){
        return YES;
    }
    return [self tableView:tableView canEditRowAtIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSManagedObject *object = [self resultObjectAtIndexPath:indexPath];
//    if(![container isKindOfClass:[ICFolder class]] || !container.isDeletable){
//        return NO;
//    }
//    return self.folderListMode == 0;
    return NO;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
- (void)didSelectObject:(Event *)object{
    [object setValue:NSDate.date forKey:@"timestamp"];
    int i = arc4random_uniform(_sectionKeys.count);
    NSString *curr = [object valueForKey:@"sectionKey"];
    NSString *n = _sectionKeys[i];
    if(![curr isEqualToString:n]){
     //   [object setValue:n forKey:@"sectionKey"];
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self deselectObject:object animated:YES];
}

- (NSString *)sectionHeaderTitleForObject:(Event *)event{
    return event.sectionKey;
}

// testing
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    return NO;
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(Event *)object{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
        //Event *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

//- (void)configureCell:(EventTableViewCell *)cell withObject:(NSManagedObject *)object{
//    //cell.textLabel.text = [[object valueForKey:@"timestamp"] description];
//    cell.fetchedResult = object;
//}

- (void)observedChangeOfFetchItemKeyPath:(NSString *)keyPath{
    NSDictionary *d = self.fetchItem;
    self.navigationItem.title = d[@"sectionKey"];
}

#pragma mark - Fetched results controller

- (void)newFetchedResultsController{
//- (NSFetchedResultsController *)fetchedResultsController
//{
//    if (_fetchedResultsController != nil) {
//        return _fetchedResultsController;
//    }
    
    NSManagedObjectContext * context = self.persistentContainer.viewContext;
    //NSManagedObjectContext * context = [NSManagedObjectContext.alloc initWithConcurrencyType:NSMainQueueConcurrencyType];
    //context.parentContext = self.persistentContainer.viewContext;
    //context.mcd_automaticallyMergesChangesFromParent = YES;
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
   // NSDictionary *d = self.fetchItem;
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sectionKey = %@", d[@"sectionKey"]];
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
   
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionKey" ascending:YES];
    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor1, sortDescriptor2]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    self.fetchedResultsController = [NSFetchedResultsController.alloc initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:@"sectionKey" cacheName:nil];
    //aFetchedResultsController.delegate = self;
   // self.fetchedResultsController = aFetchedResultsController;
    
//    NSError *error = nil;
//    if (![self.fetchedResultsController performFetch:&error]) {
//         // Replace this implementation with code to handle the error appropriately.
//         // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
//        abort();
//    }
    
    //return _fetchedResultsController;
}    

/*
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}
*/

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end
