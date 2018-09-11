//
//  DetailViewController.m
//  MCoreDataDemo
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

//static NSString * const DetailViewControllerDetailObjectKey = @"DetailObject";

NSString * const DetailViewControllerDetailObjectKey = @"DetailViewControllerDetailObjectKey";

@interface DetailViewController ()<NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation DetailViewController
//@synthesize object = _object;

//+ (nullable UIViewController *)viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{
//    return nil;
//}

- (void)awakeFromNib{
    [super awakeFromNib];
    NSLog(@"awakeFromNib %@", self);
   // self.restorationClass = self.class;
}

//- (void)willMoveToParentViewController:(UIViewController *)parent{
//    NSLog(@"%@", parent);
//}
//
- (void)didMoveToParentViewController:(UIViewController *)parent{
    [super didMoveToParentViewController:parent];
    id i = parent.parentViewController;
    NSLog(@"%@", parent.navigationController);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
//    if(self.splitViewController.isCollapsed && self.navigationController.isMovingFromParentViewController){
//        self.object = nil;
//    }
//    if (!self.parentViewController.parentViewController){ //} || [self.parentViewController isMovingFromParentViewController])
//        NSLog(@"View controller was popped");
//    }
//    else
//    {
//        NSLog(@"New view controller was pushed");
//    }
    
//    UIViewController *u = self.presentingViewController;
//    UIViewController *pvc = self.parentViewController;
//    if(!pvc){
//        // when going back in landscape or portrait.
//        self.viewedObject = nil;
//    }
//    else if(!pvc.parentViewController){
//        // doesn't happen
//        self.viewedObject = nil;
//    }
}


//- (NSManagedObjectContext *)managedObjectContext{
//    if(!_managedObjectContext){
//        _managedObjectContext = self.object.managedObjectContext;
//    }
//    return _managedObjectContext;
//}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];
    //NSManagedObjectID *objectID = self.object.objectID;
    if(self.mcd_detailObject){
        [coder encodeObject:self.mcd_detailObject.objectID.URIRepresentation forKey:DetailViewControllerDetailObjectKey];
    }
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];
}
//    NSURL *objectURI = [coder decodeObjectForKey:kDetailObjectKey];
//    if(objectURI){
//        self.viewedObject = [self.managedObjectContext mcd_objectWithURI:objectURI];
//    }
//}

#pragma mark - Managing the detail item

- (void)setEvent:(Event *)event{
    if (_event == event) {
        return;
    }
    _event = event;
    self.fetchedResultsController = nil;
    //id i = object.changedValuesForCurrentEvent;
        // Update the view.
       // [self configureView];
    if(self.isViewLoaded){
        [self configureView];
    }
}

- (NSManagedObject *)mcd_detailObject{
    return self.fetchedResultsController.fetchedObjects.firstObject;
}

//- (Event *)event{
//    return (Event *)self.object;
//}

- (void)configureView {
    // Update the user interface for the detail item.
    //if (self.viewedObject) {
    self.detailDescriptionLabel.text = [[self.mcd_detailObject valueForKey:@"timestamp"] description];
    //}
}

//- (void)setDetailItem:(id)newDetailItem {
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//
//        // Update the view.
//        [self configureView];
//    }
//}
//
//- (void)configureView {
//    // Update the user interface for the detail item.
//    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timestamp"] description];
//    }
//}

// splitview is nil in view did load
- (void)viewDidLoad {
    [super viewDidLoad];
    id i = self.splitViewController;

    NSLog(@"viewDidLoad %@", self);
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    NSLog(@"%@ %@", NSStringFromSelector(_cmd), self);
}

- (IBAction)buttonTapped:(id)sender{
    UIBarButtonItem *item = (UIBarButtonItem *)sender;
    item.enabled = NO;
}

//- (NSManagedObject *)mcd_detailObject{
//    return self.detailItem;
//}

#pragma mark - fetch controller

- (NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController){
        return _fetchedResultsController;
    }
    Event *event = self.event;
    if(!event){
        return nil;
    }
    // better here than in the lazy getter becaue it needs to return nil in case of no event yet.
    NSFetchRequest<Event *> *fetchRequest = Event.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"self = %@", event];
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:event.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    [self configureView];
}


@end
