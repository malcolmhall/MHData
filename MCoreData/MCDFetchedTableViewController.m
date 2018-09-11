//
//  MCDFetchedResultsTableViewController.m
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//
// clears selection on will appear (defaults yes).
// Trying if clears selection is off then means they want something always selected in landscape.

// Folders should not be selected like Notes when going back.

// We need the views updated in viewDidLoad instead of appear otherwise going back deselect row animation after restore doesn't appear.

// We can't have the folder remain selected

// If the most recent save is a background save then fetch controller cache is gone.

// Need to pick first cell in the table because otherwise get in a mess when collapsing.

#import "MCDFetchedTableViewController.h"
#import "MCDTableViewCell.h"
#import "NSManagedObjectContext+MCD.h"
#import <objc/runtime.h>

//static NSString * const kDefaultmessageWhenNoRows = @"There is no data available to display";
//static void * const kMCDFetchedResultsTableViewControllerKVOContext = (void *)&kMCDFetchedResultsTableViewControllerKVOContext;

@interface MCDFetchedTableViewController()
@property (nonatomic, assign) BOOL sectionsCountChanged;
// used to help select a row close to the deleted one.
@property (nonatomic, strong, nullable) NSIndexPath *selectionPathOfDeletedRow;
// used to differentiate between edit button and swipe to delete.
@property (nonatomic, strong, nullable) NSIndexPath *tableViewEditingRowIndexPath;
// when entering edit the selected row is deselected so this hangs onto it so we can select a nearby row.
@property (nonatomic, strong, nullable) NSIndexPath *selectedRowBeforeEditing;

//@property (nonatomic, assign) BOOL needsToUpdateViewsForCurrentFetchController;
@end

@interface UITableViewCell()
- (id)selectionSegueTemplate;
@end

@implementation MCDFetchedTableViewController
@synthesize fetchedResultsController = _fetchedResultsController;

- (void)viewDidLoad{
    [super viewDidLoad];
    //self.tableView.allowsSelectionDuringEditing = YES;
    /*
    DetailViewController *shownViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    NSAssert(self.managedObjectContext, @"MasterViewController requries a context");
    // shownViewController.managedObjectContext = self.managedObjectContext;
    self.shownViewController = shownViewController;
    */
    
//    self.fetchedTableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
//    self.fetchedTableData.delegate = self;
    if(![self.tableView dequeueReusableCellWithIdentifier:@"Cell"]){
        [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetailTargetDidChange:) name:UIViewControllerShowDetailTargetDidChangeNotification object:self.splitViewController];
    
    if(self.isFetchedResultsControllerCreated){
        [self updateViewsForCurrentFetchController];
    }
}

// update cell accessories.
- (void)showDetailTargetDidChange:(NSNotification *)notification{
    NSLog(@"showDetailTargetDidChange");
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [self tableView:self.tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
}

// rename to should Currently
- (BOOL)shouldAlwaysHaveSelectedObject{
    //if(self.splitViewController.isCollapsed){
    if(!self.shouldHaveSelectedObjectWhenNotInEditMode){
        return NO;
    }
    else if(self.tableView.isEditing){
        return NO;
    }
    return !self.isMovingOrDeletingObjects;
}

- (BOOL)shouldHaveSelectedObjectWhenNotInEditMode{
    // splitViewController  traitCollection horizontalSizeClass
    // isInHardwareKeyboardMode
    //return !self.splitViewController.isCollapsed;
    //return self.traitCollection.horizontalSizeClass != UIUserInterfaceSizeClassCompact;
    //return !self.clearsSelectionOnViewWillAppear;
    BOOL pushes;
    if(self.showsDetail){
        pushes = [self mcd_willShowingDetailViewControllerPushWithSender:self];
    } else {
        pushes = [self mcd_willShowingViewControllerPushWithSender:self];
    }
    return !pushes;
}

// we need the fetch controller to fetch so that it can be used by the restore stuff
- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
    if(fetchedResultsController == _fetchedResultsController){
        return;
    }
    if(_fetchedResultsController.delegate == self){
        _fetchedResultsController.delegate = nil;
    }
    _fetchedResultsController = fetchedResultsController;
    if(!fetchedResultsController.delegate){
        fetchedResultsController.delegate = self;
    }
    if(!self.fetchedResultsController.fetchedObjects){
        [self.fetchedResultsController performFetch:nil];
    }
    //[self updateViewsForCurrentFetchControllerIfNecessary];
    if(self.isViewLoaded){
        [self updateViewsForCurrentFetchController];
    }
}

- (NSFetchedResultsController *)fetchedResultsController{
    if(_fetchedResultsController){
        return _fetchedResultsController;
    }
    [self createFetchedResultsController];
    return _fetchedResultsController;
}

- (void)createFetchedResultsController{
    // overridden
}

- (BOOL)isFetchedResultsControllerCreated{
    return _fetchedResultsController != nil;
}

// bug in restoration that selected cell does not unhighlight.
// we don't select a row if nothing was selected before.
- (void)viewWillAppear:(BOOL)animated{
    self.clearsSelectionOnViewWillAppear = !self.shouldAlwaysHaveSelectedObject;
    [super viewWillAppear:animated]; // if numberOfSections == 0 then it reloads data. But reloads anyway because of didMoveToWindow. It also clears selection.
    
//    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
//        //if ([self isPushingForIndexPath:indexPath]) {
//        if(self.isPushing){
//            // If we're pushing for this indexPath, deselect it when we appear
//            [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
//        }
//    }
    
    // reselect row if it is showing on right
//    NSManagedObject *visibleObject =
//    if (visibleObject) {
//         = visibleObject;
//        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:visibleObject] ;//[self indexPathContainingDetailObject:visibleObject];
//        if(indexPath){
//            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
//            return;
//        }
 //   }
//    NSManagedObject *object = self.fetchedResultsController.fetchedObjects.firstObject;
//    [self showDetailObjectForObject:object];
    
    // reason for dispatch is when seperating from portrait we cant find the detail object.
    //dispatch_async(dispatch_get_main_queue(), ^{
    [self updateSelectionInTableViewAnimated:NO];
    //});
//    //[self updateSelectionForCurrentViewedObjectAnimated:animated];
//    if(self.needsToUpdateViewsForCurrentFetchController){
//        [self updateViewsForCurrentFetchController];
//    }
    //if([NSStringFromClass(self.class) isEqualToString:@"InitialViewController"]){
        //[self performSelector:@selector(aaa) withObject:nil afterDelay:10];
    //}
    // this is for when in split and reselecting what is in detail. Not when seperating because detail object is nil.
}

// the default segue in master-detail template is showDetail so we will default to that.
- (BOOL)showsDetail{
    return YES;
}

//- (void)updateViewsForCurrentFetchControllerIfNecessary{
//    if(self.isViewLoaded && self.tableView.window){
//        [self updateViewsForCurrentFetchController];
//    }else{
//        self.needsToUpdateViewsForCurrentFetchController = YES;
//    }
//}

- (void)updateViewsForCurrentFetchController{
    [self.tableView reloadData];

    NSManagedObject *selectedObject = [self mcd_currentVisibleDetailObjectWithSender:self];
    if(!selectedObject){
        self.selectedObject = self.fetchedResultsController.fetchedObjects.firstObject;
        [self showSelectedObject];//:self.fetchedResultsController.fetchedObjects.firstObject startEditing:NO];
        return;
    }
    
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:selectedObject];
    if(!indexPath){
        self.selectedObject = self.fetchedResultsController.fetchedObjects.firstObject;
        [self showSelectedObject];//:self.fetchedResultsController.fetchedObjects.firstObject startEditing:NO];
        return;
    }
//    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:0];
//    [self showNotesListNote:note startEditing:self.noteEditorIsEditing];
}

// endEditMode
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self updateSelectionInTableViewAnimated:animated];
}

- (NSArray *)tableViewIndexPathsForSelectedEditableRows{
    if(self.tableViewEditingRowIndexPath){
        return @[self.tableViewEditingRowIndexPath];
    }
    return self.tableView.indexPathsForSelectedRows.copy;
}

- (void)updateSelectionInTableViewAnimated:(BOOL)animated{
    [self updateSelectionInTableViewAnimated:animated scrollToSelection:NO];
}

// only for when pushign doesnt work with rotation.
//- (void)updateSelectionInTableViewAnimated:(BOOL)animated scrollToSelection:(BOOL)scrollToSelection{
//    NSManagedObject *object = [self mcd_currentVisibleDetailObjectWithSender:self];
//    if(!object || !self.shouldAlwaysHaveSelectedObject){
//        return;
//    }
//    //NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
//    NSIndexPath *indexPath = [self indexPathContainingDetailObject:object];
//    if(!indexPath){
//        return;
//    }
//    UITableView *tableView = self.tableView;
//    [tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:0];
//    if(!scrollToSelection){
//        return;
//    }
//    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:animated];
//}

// ICNotesListViewController
// Called from note container did change.
// tables been reloaded so shouldn't be anything to deselect, the return is important though. Maybe also showing a nil object is too though.
//- (void)updateSelectionForFetchedObjectsAnimated:(BOOL)animated{
    // if in portrait we don't show detail objects.
    //    NSUInteger i = self.tableViewIndexPathsForSelectedEditableRows.count;
    //    if(!self.tableViewIndexPathsForSelectedEditableRows.count){
    //        // if doesnt show detail among other things
    //        if(!self.shouldAlwaysHaveSelectedObject){
    //            if(!self.tableView.isEditing){
    //                for(NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows.copy){
    //                    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    //                }
    //            }
    //            return;
    //        }
    //    }
//    if(!self.shouldAlwaysHaveSelectedObject){
//        return;
//    }
//    // doesnt find the object when seperating
//    NSManagedObject *object = [self mcd_currentVisibleDetailObjectWithSender:self];//self.shownViewController.viewedObject;
//    if(object){
//        // checks if the detail object exists in this fetch
//        id i = self.fetchedResultsController.fetchedObjects;
//        NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];// [self indexPathForNote:note];
//        if(indexPath){
//            // it will be selected in viewWillAppears
//            return;
//        }
//    }
//    // default to first object.
//    object = self.fetchedResultsController.fetchedObjects.firstObject;
//    if(object){
//        NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//        [self.tableView selectRowAtIndexPath:firstIndex animated:animated scrollPosition:0];
//    }
//    [self showObject:object startEditing:NO];
//}

- (void)updateSelectionInTableViewAnimated:(BOOL)animated scrollToSelection:(BOOL)scrollToSelection{
    if(!self.shouldAlwaysHaveSelectedObject){
        return;
    }
    NSManagedObject *object = self.selectedObject;
    if(!object){
        return;
    }
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
    if(!indexPath){
        return;
    }
    UITableView *tableView = self.tableView;
    [tableView selectRowAtIndexPath:indexPath animated:animated scrollPosition:0];
    if(scrollToSelection){
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:0 animated:animated];
    }
}

#pragma mark - UITableViewDataSource

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!self.isEditing){
        self.selectedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    return indexPath;
}

// called by didMoveToWindow aswell and layoutsubviews
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UITableViewCell *cell = [self cellForObject:object atIndexPath:indexPath];
    if([indexPath isEqual:tableView.indexPathForSelectedRow]){
        cell.selected = YES;
    }
    [self configureCell:cell withObject:object];
    return cell;
    //    if(![object conformsToProtocol:@protocol(MCDTableViewCellObject)]){
//        return nil;
//    }
//    static NSString *kCellIdentifier = @"MCDTableViewCell";
    //MCDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MCDTableViewCell"];
//    if(!cell){
//        cell = [MCDTableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
//    }
    //return cell;
}

- (BOOL)shouldShowDetailForIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL pushes;
   // if ([self shouldShowConversationViewForIndexPath:indexPath]) {
    if([self shouldShowDetailForIndexPath:indexPath]){
        pushes = [self mcd_willShowingDetailViewControllerPushWithSender:self];
    } else {
        pushes = [self mcd_willShowingViewControllerPushWithSender:self];
    }
    
    // Only show a disclosure indicator if we're pushing
    if (pushes) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (UITableViewCell *)cellForObject:(NSManagedObject *)object atIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
//    if([object respondsToSelector:@selector(subtitleForTableViewCell)]){
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Subtitle"];
//        if(!cell){
//            cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Subtitle"];
//        }
//    }
//    else{
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"Default"];
//        if(!cell){
//            cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Default"];
//        }
//    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject<MCDTableViewCellObject> *)object{
    //if([object conformsToProtocol:@protocol(MCDTableViewCellObject)]){
    NSManagedObject<MCDTableViewCellObject> *cellObject = (NSManagedObject<MCDTableViewCellObject> *)object;
    cell.textLabel.text = cellObject.titleForTableViewCell;
    if([object respondsToSelector:@selector(subtitleForTableViewCell)]){
        cell.detailTextLabel.text = cellObject.subtitleForTableViewCell;
    }else{
        cell.detailTextLabel.text = nil;
    }
    //}
}

//- (void)configureViewer:(id<MCDObjectViewer>)viewer withObject:(NSManagedObject *)object{
//    viewer.object = object;
//}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(controller != self.fetchedResultsController){
        return;
    }
    //    if([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]){
    //        [self.delegate controllerWillChangeContent:controller];
    //    }
    NSLog(@"Begin Updates");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if(controller != self.fetchedResultsController){
        return;
    }
    switch(type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"Section Insert");
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            self.sectionsCountChanged = YES;
            break;
        case NSFetchedResultsChangeDelete:
            NSLog(@"Section Delete");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            self.sectionsCountChanged = YES;
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"Section Move");
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Section Update");
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    //    if([self.delegate respondsToSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]){
    //        [self controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    //    }
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"Insert %@", newIndexPath);
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
        {
            // can be deleted by user or system.
            // can be in edit mode or not.
            // always needs a new one shown
            // but only sometimes needs table row selected.
            
            // problem is without a selected row the segue won't work.
            
            // we cant just set it nil because then would need to also clear any child controllers so best we do a segue
            NSLog(@"Delete %@", indexPath);
            //NSManagedObject *visibleObject = [self mcd_currentVisibleDetailObjectWithSender:self]; // nil because it has already been deleted from the detail controller.
            //if(visibleObject){
            //    NSIndexPath *ip = [self indexPathContainingDetailObject:visibleObject];
            if(anObject == self.selectedObject){
                    // if the selected row was deleted we will keep the index to select a nearby row.
                self.selectionPathOfDeletedRow = indexPath;
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove:
            NSLog(@"Move %@ to %@", indexPath, newIndexPath);
            // Can't use the tableView move method becasue its animation does not play with section inserts/deletes.
            // Also if we used move would need to update the cell manually which might use the wrong index.
            // Even if old and new indices are the same we still need to call the methods.
            if(self.sectionsCountChanged || indexPath.section != newIndexPath.section){
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                //[NSNotificationCenter.defaultCenter postNotificationName:MCDFetchedTableViewControllerObjectUpdated object:anObject];
            }
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
        case NSFetchedResultsChangeUpdate:
            // Using KVO to optimise update of cells.
            //NSLog(@"Update %@ to %@", indexPath, newIndexPath);
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            //configureCell
            //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            // this was bad practice I think
            //if([indexPath isEqual:tableView.indexPathForSelectedRow]){
                //self.shownViewController.viewedObject = anObject;
            //}
            //[NSNotificationCenter.defaultCenter postNotificationName:MCDFetchedTableViewControllerObjectUpdated object:anObject];
            break;
            /*
             case NSFetchedResultsChangeUpdate:
             NSLog(@"Update");
             // previously we called configure cell but that didn't allow an update to change cell type.
             [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             break;
             
             case NSFetchedResultsChangeMove:
             {
             //NSLog(@"Move");
             if(![indexPath isEqual:newIndexPath]){
             //NSLog(@"Move %@ to %@", indexPath, newIndexPath);
             // move assumes reload however if we do both it crashes with 2 animations cannot be done at the same time.
             //                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
             //                dispatch_async(dispatch_get_main_queue(), ^{
             //                    [tableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             //                });
             // test
             // todo think there was another way to do this in another project.
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             
             }else{
             //NSLog(@"Move %@", indexPath);
             // it hadn't actually moved but it was updated. Required as of iOS 9.
             [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
             }
             break;
             }
             */
    }
}

// the reselection after deleted row needs to be done here because the row could be deleted from the list from sync.
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(controller != self.fetchedResultsController){
        return;
    }
    self.sectionsCountChanged = NO;
    [self.tableView endUpdates];
    // selection must be after the updates or doesn't select during non-user delete.
    // doesn't happen if currently editing or have swiped. So only happens when sync causes a delete.
    // gonna make it work for both cases.
    //if(self.shouldAlwaysHaveSelectedObject){
    NSIndexPath *indexPath = self.selectionPathOfDeletedRow;
    if(indexPath){
        self.selectionPathOfDeletedRow = nil;
        [self selectTableViewRowNearIndexPath:indexPath];
    }
    
    if([controller.managedObjectContext hasChanges]){
        NSLog(@"yes");
    }
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableViewEditingRowIndexPath = indexPath;
    [super tableView:tableView willBeginEditingRowAtIndexPath:indexPath];
    //[r20 updateNavAndBarButtonsAnimated:0x0];
}

// since during swipe to delete the selection highlight is lost we need to bring it back.
-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    [super tableView:tableView didEndEditingRowAtIndexPath:indexPath];
    if(indexPath){
        if(![self.tableViewEditingRowIndexPath isEqual:indexPath]){
            NSLog(@"Note list table view editing index path mismatch %@ expects %@", indexPath, self.tableViewEditingRowIndexPath);
        }
    }
    self.tableViewEditingRowIndexPath = nil;
    //NSIndexPath *ip = tableView.indexPathForSelectedRow;
    // [r20 updateNavAndBarButtonsAnimated:0x0];
}

//- (void)scrollToObject:(id)object{
//    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
//    //NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
//    //indexPath = [self indexPathForFolderInTableViewFromFetchedResultsControllerIndexPath:indexPath managedObjectContext:context];
//    if(indexPath){
//        if(![self.tableView.indexPathsForVisibleRows containsObject:indexPath]){
//            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
//        }
//    }
//}

// if there are more rows beyond the index then use current index otherwise use 1 less.
- (void)selectTableViewRowNearIndexPath:(NSIndexPath *)indexPath{
   // NSAssert(!self.tableView.isEditing, @"Cannot select while editing");
    NSUInteger count = self.fetchedResultsController.fetchedObjects.count;
    NSManagedObject *object;
    if(count){
        NSUInteger row = count - 1;
        if(indexPath.row < row){
            row = indexPath.row;
        }
        NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        object = [self.fetchedResultsController objectAtIndexPath:ip];
        //UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:indexPath.section]];
        //id c = cell.selectionSegueTemplate; // UIStoryboardShowSegueTemplate
       
        // select the row so it'll work in prepareForSegue.
        // it wont work if editing but update selection after editing will
        [self.tableView selectRowAtIndexPath:ip animated:NO scrollPosition:0];
        //[[cell selectionSegueTemplate] performSelector:NSSelectorFromString(@"perform:") withObject:cell];
    }
    self.selectedObject = object;
    if(!self.splitViewController.isCollapsed){
        [self showSelectedObject];
    }
}

//- (void)showObject:(nullable NSManagedObject *)object startEditing:(BOOL)startEditing{
- (void)showSelectedObject{
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return !self.isEditing;
}

//- (void)configureDetailViewControllerWithObject:(NSManagedObject *)object{
//    self.shownViewController.viewedObject = object;
//}

//- (void)showDetailObject:(id)viewedObject{
//    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:viewedObject];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [self performSegueWithIdentifier:@"showDetail" sender:cell];
//}

#pragma mark - Restoration

// on encode it asks for first and selected. On restore it asks for first so maybe checks ID.
- (nullable NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view{
    //NSAssert(self.fetchedResultsController.fetchedObjects, @"modelIdentifierForElementAtIndexPath requires fetchedObjects");
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:idx];
    return object.objectID.URIRepresentation.absoluteString;
}

- (nullable NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view{
    NSURL *objectURI = [NSURL URLWithString:identifier];
  //  NSAssert(self.managedObjectContext, @"indexPathForElementWithModelIdentifier requires a context");
    NSManagedObject *object = [self.fetchedResultsController.managedObjectContext mcd_objectWithURI:objectURI];
    //[self.tableView reloadData];
  //  NSAssert(self.fetchedResultsController.fetchedObjects, @"indexPathForElementWithModelIdentifier requires fetchedObjects");
    return [self.fetchedResultsController indexPathForObject:object];
}

- (void)applicationFinishedRestoringState{
 //   [self updateSelectionInTableViewAnimated:NO];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder{
    [super encodeRestorableStateWithCoder:coder];

//
//    id i = self.tableView.indexPathForSelectedRow;
//    NSLog(@"");
//
//    NSManagedObjectID *objectID = dvc.viewedObject.objectID;
//    if(!objectID){
//        return;
//    }
//    [coder encodeObject:objectID.URIRepresentation forKey:kDetailObjectKey];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder {
    [super decodeRestorableStateWithCoder:coder];

    //[self.tableView reloadData];
//    NSURL *objectURL = [coder decodeObjectForKey:kDetailObjectKey];
//    if(!objectURL){
//        return;
//    }
//    NSManagedObjectContext *moc = context;
//    NSManagedObjectID *objectID = [moc.persistentStoreCoordinator managedObjectIDForURIRepresentation:objectURL];
//    if(!objectID){
//        return;
//    }
//    NSManagedObject *object = [moc objectWithID:objectID];
//    dvc.viewedObject = object;
}

@end

@implementation UIViewController (AAPLPhotoContents)

//- (NSManagedObject *)mcd_detailObject{
//    return objc_getAssociatedObject(self, @selector(mcd_detailObject));
//}
//
//- (void)mcd_setDetailObject:(NSManagedObject *)object {
//    objc_setAssociatedObject(self, @selector(mcd_detailObject), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//- (NSManagedObject *)mcd_detailObject{
//    // By default, view controllers don't contain photos
//    return nil;
//}

- (BOOL)mcd_viewedObjectContainsDetailObject:(NSManagedObject *)object{
    // By default, view controllers don't contain photos
    return NO;
}

- (nullable NSManagedObject *)mcd_currentVisibleDetailObjectWithSender:(id)sender{
    // Look for a view controller that has a visible photo
    UIViewController *target = [self targetViewControllerForAction:@selector(mcd_currentVisibleDetailObjectWithSender:) sender:sender];
    if (target) {
        return [target mcd_currentVisibleDetailObjectWithSender:sender];
    } else {
        return nil;
    }
}

//- (nullable NSManagedObject *)mcd_currentVisibleObjectWithSender:(id)sender{
//    UIViewController *target = [self targetViewControllerForAction:@selector(mcd_currentVisibleObjectWithSender:) sender:sender];
//    if (target) {
//        return [target mcd_currentVisibleObjectWithSender:sender];
//    } else {
//        return nil;
//    }
//}

@end

@implementation UISplitViewController (AAPLPhotoContents)

- (nullable NSManagedObject *)mcd_currentVisibleDetailObjectWithSender:(id)sender{
    if (self.collapsed) {
        // If we're collapsed, we don't have a detail
        return nil;
    } else {
        // Otherwise, return our detail controller's contained photo (if any)
        NSAssert(self.viewControllers.count == 2, @"Collapsed doesnt have 2 view controllers, try dispatch_async");
        UIViewController *controller = self.viewControllers.lastObject;
        return controller.mcd_detailObject;
        //return [controller mcd_currentVisibleDetailObjectWithSender:sender];
    }
}

@end

@implementation UINavigationController (AAPLPhotoContents)

- (NSManagedObject *)mcd_detailObject{
    id i = self.viewControllers;
    UIViewController *controller = self.topViewController;
    return controller.mcd_detailObject;
}

//- (nullable NSManagedObject *)mcd_currentVisibleObjectWithSender:(id)sender{
//    NSUInteger index = [self.viewControllers indexOfObject:sender];
//    index++;
//    if(self.viewControllers.count >= index){
//        return nil;
//    }
//    UIViewController *vc = [self.viewControllers objectAtIndex:index];
//    return vc.mcd_detailObject;
//}

@end


@implementation UIViewController (AAPLViewControllerShowing)

- (BOOL)mcd_willShowingViewControllerPushWithSender:(id)sender
{
    // Find and ask the right view controller about showing
    UIViewController *target = [self targetViewControllerForAction:@selector(mcd_willShowingViewControllerPushWithSender:) sender:sender];
    if (target) {
        return [target mcd_willShowingViewControllerPushWithSender:sender];
    } else {
        // Or if we can't find one, we won't be pushing
        return NO;
    }
}

- (BOOL)mcd_willShowingDetailViewControllerPushWithSender:(id)sender
{
    // Find and ask the right view controller about showing detail
    UIViewController *target = [self targetViewControllerForAction:@selector(mcd_willShowingDetailViewControllerPushWithSender:) sender:sender];
    if (target) {
        return [target mcd_willShowingDetailViewControllerPushWithSender:sender];
    } else {
        // Or if we can't find one, we won't be pushing
        return NO;
    }
}

@end

@implementation UINavigationController (AAPLViewControllerShowing)

- (BOOL)mcd_willShowingViewControllerPushWithSender:(id)sender
{
    // Navigation Controllers always push for showViewController:
    return YES;
}

@end

@implementation UISplitViewController (AAPLViewControllerShowing)

- (BOOL)mcd_willShowingViewControllerPushWithSender:(id)sender
{
    // Split View Controllers never push for showViewController:
    return NO;
}

- (BOOL)mcd_willShowingDetailViewControllerPushWithSender:(id)sender
{
    if (self.collapsed) {
        // If we're collapsed, re-ask this question as showViewController: to our primary view controller
        UIViewController *target = self.viewControllers.lastObject;
        return [target mcd_willShowingViewControllerPushWithSender:sender];
    } else {
        // Otherwise, we don't push for showDetailViewController:
        return NO;
    }
}

@end



