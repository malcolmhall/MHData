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
//#import "EventTableViewData.h"

//static NSString * const kDetailObjectKey = @"DetailObject";
NSString * const MasterViewControllerDetailObjectKey = @"DetailObject";
//static NSManagedObjectContext *_managedObjectContext = nil;

@interface MasterViewController ()
//<MCDFetchedTableDataDelegate>
@property (assign) BOOL malc;
@end

@implementation MasterViewController{
    NSArray *_sectionKeys;
}

//+ (NSManagedObjectContext *)managedObjectContext{
//    return _managedObjectContext;
//}
//
//+ (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
//    _managedObjectContext = managedObjectContext;
//}

// we return nil when we don't want the controller restored.
//+ (UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray<NSString *> *)identifierComponents
//                                                            coder:(NSCoder *)coder{
//    NSURL *objectURI = [coder decodeObjectForKey:MasterViewControllerDetailObjectKey];
//    if(!objectURI){
//        return nil;
//    }
//    NSManagedObject *object = [self.managedObjectContext mcd_existingObjectWithURI:objectURI error:nil];
//    if(!object){
//        return nil;
//    }
//    UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
//    MasterViewController *master = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
//    master.masterItem = object;
//    return master;
//}

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
    //self.restorationClass = self.class;
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];
    if(self.masterItem){
        [coder encodeObject:self.masterItem.objectID.URIRepresentation forKey:MasterViewControllerDetailObjectKey];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
    NSURL *objectURI = [coder decodeObjectForKey:MasterViewControllerDetailObjectKey];
//    if(objectURI){
//        _masterItem = (Venue *)[self.managedObjectContext mcd_objectWithURI:objectURI];
//    }
}

//- (instancetype)initWithStyle:(UITableViewStyle)style x:(int)x{
//    self = [self initWithStyle:style];
//    if(self){
//        self.view = nil;
//    }
//    return self;
//}

//- (void)showObject:(nullable NSManagedObject *)object startEditing:(BOOL)startEditing{
//    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
- (void)showSelectedObject{
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

//- (NSManagedObjectContext *)managedObjectContext{
//    NSManagedObjectContext *moc = super.managedObjectContext;
//    if(!moc){
//        return self.masterItem.managedObjectContext;
//    }
//    return moc;
//}

- (IBAction)teardownButtonTapped:(id)sender{
    //self.fetchedTableData.fetchedResultsController = nil;
    //self.fetchedResultsController = nil;
//    NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"sectionKey" ascending:YES];
//    NSSortDescriptor *sortDescriptor2 = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
//
//
//    self.fetchedResultsController.fetchRequest.sortDescriptors = @[sortDescriptor1, sortDescriptor2];
    self.fetchedResultsController = nil;
    //[self.tableView reloadData];
}
    
- (IBAction)recreateButtonTapped:(id)sender{
    /*
    NSPersistentStore *store = self.managedObjectContext.persistentStoreCoordinator.persistentStores.firstObject;
    NSURL *url = store.URL;
    url = [url URLByDeletingLastPathComponent];
    url = [url URLByAppendingPathComponent:@"malc.sqlite"];
    store.URL = url;
    NSError *error = nil;
    [self.managedObjectContext.persistentStoreCoordinator mcd_destroyPersistentStore:store error:&error];
    if(error){
        NSLog(@"%@", error);
    }
    NSArray *a = self.managedObjectContext.persistentStoreCoordinator.persistentStores;
    NSLog(@"");
    
    [self.managedObjectContext.persistentStoreCoordinator.mcd_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull a , NSError * _Nullable e) {
        NSLog(@"");
    }];
    */
    // return;
    //self.view = nil;
    // self.malc = YES;
    //self.view = nil;
    //[self reloadView];  
    //    [self performSelector:@selector(unloadViewIfReloadable)];
    //    BOOL i = [self isViewLoaded];
    //    [self.tableView reloadData];
    //[self.fetchedTableData fetchAndReloadData];
    //    self.fetchedResultsController = nil;
    //    [self.fetchedResultsController performFetch:nil];
    //   [self.tableView reloadData];
}

//- (void)applicationFinishedRestoringState{
//    NSIndexPath *selected = self.tableView.indexPathForSelectedRow;
//    self.shownViewController.object = [self.fetchedResultsController objectAtIndexPath:selected];
//}

//- (void)setDetailViewController:(UIViewController<MCDObjectViewer> *)shownViewController{
//    super.shownViewController = shownViewController;
//}

//- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext{
//    NSAssert(!_managedObjectContext, @"MasterViewController already has a context, cannot replace");
//    _managedObjectContext = managedObjectContext;
//}

- (void)setMasterItem:(NSManagedObject *)masterItem{
    [self setMasterItem:masterItem deleteCache:YES];
}

- (void)setMasterItem:(NSManagedObject *)masterItem deleteCache:(BOOL)deleteCache{
    if (_masterItem == masterItem) {
        return;
    }
    _masterItem = masterItem;
    
    if(deleteCache){
        [NSFetchedResultsController deleteCacheWithName:@"Master"];
    }
    if(self.isFetchedResultsControllerCreated){
        self.fetchedResultsController = nil;
    }
}

- (void)createFetchedResultsController{
    //id i = object.changedValuesForCurrentEvent;
    // Update the view.
    // [self configureView];
    //[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(objectChanged:) name:MCDFetchedTableViewControllerObjectUpdated object:object];
    //[self updateViewsFromCurrentObject];
//    if(!self.isViewLoaded){
//        return;
//    }
//    [self updateViewsFromCurrentObject];
    
    //    if(!self.malc){
    //        return;
    //    }
    //- (NSFetchedResultsController *)fetchedResultsController
    //{
    //    if (_fetchedResultsController != nil) {
    //        return _fetchedResultsController;
    //    }
    NSManagedObjectContext * context = self.managedObjectContext;
    //    if(!context){
    //        return;
    //    }
    //NSManagedObjectContext * context = [NSManagedObjectContext.alloc initWithConcurrencyType:NSMainQueueConcurrencyType];
    //context.parentContext = self.persistentContainer.viewContext;
    //context.mcd_automaticallyMergesChangesFromParent = YES;
    
    NSFetchRequest *fetchRequest = Event.fetchRequest;
    // NSDictionary *d = self.fetchItem;
    //fetchRequest.predicate = [NSPredicate predicateWithFormat:@"sectionKey = %@", d[@"sectionKey"]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"venue = %@", self.masterItem];
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
    NSFetchedResultsController *fetchedResultsController = [NSFetchedResultsController.alloc initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"Master"]; // @"sectionKey"
    //aFetchedResultsController.delegate = self;
    // self.fetchedResultsController = aFetchedResultsController;
    
    //        NSError *error = nil;
    //        if (![fetchedResultsController performFetch:&error]) {
    //             // Replace this implementation with code to handle the error appropriately.
    //             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
    //            abort();
    //        }
    self.fetchedResultsController = fetchedResultsController;
    //return _fetchedResultsController;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
 //   self.shouldAlwaysHaveSelectedRow = YES;
  //  id i = self.tableView.indexPathForSelectedRow;
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [UIBarButtonItem.alloc initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //self.shownViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    
    [self.tableView registerClass:EventTableViewCell.class forCellReuseIdentifier:@"EventTableViewCell"];
    
    //self.persistentContainer.viewContext.mcd_automaticallyMergesChangesFromParent = YES;
    //self.messageWhenNoRows = @"Sorry there are no rows";
 //   self.keyPathsForObservingFetchItem = @[@"sectionKey"];
    
    _sectionKeys = @[@"a", @"b", @"c", @"d", @"e"];
    //[self performSelector:@selector(test) withObject:nil afterDelay:2];
    //self.tableView.allowsSelectionDuringEditing = YES;
    
    //self.fetchedTableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
    //self.fetchedTableData.delegate = self;
    
//    if(self.masterItem){
//        [self updateViewsFromCurrentObject];
//    }
   // [self performSelector:@selector(timer) withObject:nil afterDelay:5];
}


- (void)timer{
    
    NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
    
    //[self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    //return;
   // NSManagedObjectContext *context = self.managedObjectContext.persistentStoreCoordinator.mcd_persistentContainer.newBackgroundContext;
    
    Event *event = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    
    [context deleteObject:event];
    [context save:nil];
    return;
    
    if(event){
        //Event *event2 = [context objectWithID:event.objectID];
        
        if(self.malc){
            event.timestamp = NSDate.distantFuture;
        }
        else{
            event.timestamp = NSDate.distantPast;
        }
        self.malc = !self.malc;
        //event.timestamp = NSDate.date;
        [event addAttendeesObject:[Attendee.alloc initWithContext:context]];
        [context save:nil];
        
        //[context save:nil];
    }
    //[self performSelector:@selector(timer) withObject:nil afterDelay:1];
}

/*
- (BOOL)fetchedTableData:(MCDFetchedTableData *)fetchedTableData canEditObject:(id)object{
    return YES;
}

- (UITableViewCell *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData cellForObject:(id)object{
    EventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Event"];
    cell.fetchedObject = object;
    return cell;
}

- (NSString *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedCellIdentifierForObject:(id)object{
    return @"Event";
}


- (nullable UISwipeActionsConfiguration *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData trailingSwipeActionsConfigurationForObject:(id)object{
    return nil;
}
*/

- (void)viewWillAppear:(BOOL)animated {
    //self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
//    if(self.isMovingToParentViewController){
//        NSLog(@"To");
//    }
//    if(self.isMovingFromParentViewController){
//        NSLog(@"From");
//    }
//    if(self.isBeingDismissed){
//        NSLog(@"Dismissed");
//    }
//
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
//    if(self.isMovingToParentViewController){
//        NSLog(@"To");
//    }
//    if(self.isMovingFromParentViewController){
//        NSLog(@"From");
//    }
//    if(self.isBeingDismissed){
//        NSLog(@"Dismissed");
//    }
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    if(self.splitViewController.isCollapsed && self.navigationController.isMovingFromParentViewController){
    //        self.object = nil;
    //    }
    UIViewController *u = self.presentingViewController;
    UIViewController *pvc = self.parentViewController;
    if(!pvc){
        // when going back in landscape or portrait.
        //self.viewedObject = nil;
    }
    else if(u){
        // doesn't happen
        //self.viewedObject = nil;
    }
    // wehen rotating
    
//    if (!vc.parentViewController){ //} || [self.parentViewController isMovingFromParentViewController])
//        NSLog(@"View controller was popped");
//    }
//    else
//    {
//        NSLog(@"New view controller was pushed");
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)insertNewObject:(id)sender {
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
    NSEntityDescription *entity = self.fetchedResultsController.fetchRequest.entity; // fetchedTableData
    if(!entity){
        return;
    }
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:entity.name inManagedObjectContext:context];
    
    // If appropriate, configure the new managed object.
    // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
    [object setValue:[NSDate date] forKey:@"timestamp"];
    [object setValue:self.masterItem forKey:@"venue"];
//    int i = arc4random_uniform(_sectionKeys.count);
//    [object setValue:_sectionKeys[i] forKey:@"sectionKey"];
    
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
    if ([segue.identifier isEqualToString:@"showDetail"]) {
//        Event *event;
//        if([sender isKindOfClass:Event.class]){
//            event = (Event *)sender;
//        }
//        else{
        //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
//        }
        //UITableViewCell *cell = (UITableViewCell *)sender;
        
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        DetailViewController *controller = (DetailViewController *)[segue.destinationViewController topViewController];
        controller.event = self.selectedObject;
        
        //controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //controller.navigationItem.leftItemsSupplementBackButton = YES;
        //self.shownViewController = controller;
    }
}

#pragma mark - Table Data

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//- (UITableViewCell *)cellForObject:(NSManagedObject *)object atIndexPath:(NSIndexPath *)indexPath{
//    EventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Event" forIndexPath:indexPath];
//    //Event *event = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    //cell.event = event;
//    return cell;
//}

//- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object{
//    cell.event = object;
//}

/*
- (nullable NSIndexPath *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedIndexPathForTableIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 || indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1){
         return nil;
    }
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
}

- (nullable NSIndexPath *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData tableIndexPathForFetchedIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.section == 0){
    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
//
}
*/

/*
- (NSInteger)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedSectionForTableSection:(NSInteger)tableSection{
    if(tableSection == 0){//} || section == [self numberOfSectionsInTableView:self.tableView] - 1){
        return NSNotFound;
    }
    return tableSection - 1;
}

- (NSInteger)fetchedTableData:(MCDFetchedTableData *)fetchedTableData tableSectionForFetchedSection:(NSInteger)fetchedSection{
    return fetchedSection + 1;
}
*/

#pragma mark - Table View

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.fetchedTableData.fetchedResultsController.sections.count + 1;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(section == 0){//} || section == [self numberOfSectionsInTableView:self.tableView] - 1){
//        return 1;
//    }
//    return NSNotFound;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MCDTableViewCell *cell;
//    if(indexPath.section == 0){//section} || indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1){
//        cell  = [tableView dequeueReusableCellWithIdentifier:@"MCD" forIndexPath:indexPath];
//        //cell.textLabel.text = @"Malc";
//    }
//    cell.object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//   // NSManagedObject * o = [self.fetchedResultsController objectAtIndexPath:indexPath];
//   // id i = o.managedObjectContext.persistentStoreCoordinator.mcd_persistentContainer;
//   // NSLog(@"%@", i);
//    
//    return cell;
//}

//- (UITableViewCell *)cellForResultObject:(NSManagedObject *)resultObject{
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
//    return cell;
//}


//- (UITableViewCell *)cellForObject:(Event *)event{
//    EventTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Event"];
//    cell.fetchedObject = event;
//    return cell;
//}

//- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(!tableView.isEditing){
//        return YES;
//    }
//    return [self tableView:tableView canEditRowAtIndexPath:indexPath];
//}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSManagedObject *object = [self resultObjectAtIndexPath:indexPath];
//    if(![container isKindOfClass:[ICFolder class]] || !container.isDeletable){
//        return NO;
//    }
//    return self.folderListMode == 0;
//    return NO;
//}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.fetchedTableData.numberOfSections + 1;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
////    if(indexPath.section > 0 && indexPath.section < [self numberOfSectionsInTableView:tableView] - 1){
////        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
////    }
//    if(indexPath.section == [self numberOfSectionsInTableView:tableView] - 1){
//        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        cell.textLabel.text = @"Malc";
//        return cell;
//    }
//    return nil;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
////    if(section > 0 && section == [self numberOfSectionsInTableView:tableView] - 1){
////        return
////    }
//    if(section == [self numberOfSectionsInTableView:tableView] - 1){
//        return 1;
//    }
//    return 0;
//}


//- (NSIndexPath *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedIndexPathForTableIndexPath:(NSIndexPath *)indexPath{
//    //if(indexPath.section == 0){//} || indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1){
//    //    return indexPath;
//    //}
//    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section - 1];
//}
//
//- (NSIndexPath *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData tableIndexPathForFetchedIndexPath:(NSIndexPath *)indexPath{
////    if(indexPath.section == 0){
////        return indexPath;
////    }
////    if(presentationIndexPath.section == 0){//} || indexPath.section == [self numberOfSectionsInTableView:self.tableView] - 1){
////        return presentationIndexPath;
////    }
//    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
//}



//
//- (NSIndexPath *)tableIndexPathFromFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath{
//    return [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section + 1];
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
////    if(section != 0){
////        return [super tableView:tableView titleForHeaderInSection:section];
////    }
////    return nil;
//    return @"Section";
//}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"did select");
//}
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

//- (NSString *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData sectionHeaderTitleForObject:(Event *)event{
//    return event.sectionKey;
//}
//}

// testing
//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    return NO;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
//- (void)fetchedTableData:(MCDFetchedTableData *)fetchedTableData commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(id)object{
    
    BOOL b = self.tableView.isEditing;
    
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
//    NSDictionary *d = self.fetchItem;
//    self.navigationItem.title = d[@"sectionKey"];
}

#pragma mark - Fetched results controller

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


//- (NSManagedObject *)mcd_detailObject{
//    return self.masterItem;
//}

- (void)dealloc
{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
}

@end
