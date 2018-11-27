//
//  MCDFetchedTableDataSource.m
//  MCoreData
//
//  Created by Malcolm Hall on 15/09/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//
// Should support deletion of selected row by a background context

#import "MCDFetchedTableDataSource.h"
#import <objc/runtime.h>
#import "NSManagedObjectContext+MCD.h"

@interface MCDFetchedTableDataSource()

@property (nonatomic, assign) BOOL sectionsCountChanged;
//@property (nonatomic, strong) NSIndexPath *selectedRowBeforeChanges;
@property (weak, nonatomic) UITableView *tableView;

@end

@implementation MCDFetchedTableDataSource

//- (instancetype)initWithTableView:(UITableView *)tableView{
- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{//} tableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
//        tableView.dataSource = self;
        fetchedResultsController.delegate = self;
        _fetchedResultsController = fetchedResultsController;
    }
    return self;
}

- (void)setTableView:(UITableView *)tableView{
    if(tableView == _tableView){
        return;
    }
    if(![tableView dequeueReusableCellWithIdentifier:@"Cell"]){
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
    }
    _tableView = tableView;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject<MCDTableViewCellObject> *)object{
    cell.textLabel.text = object.titleForTableViewCell;
    if([object respondsToSelector:@selector(subtitleForTableViewCell)]){
        cell.detailTextLabel.text = object.subtitleForTableViewCell;
    }
    if([self.delgate respondsToSelector:@selector(fetchedTableDataSource:configureCell:withObject:)]){
        [self.delgate fetchedTableDataSource:self configureCell:cell withObject:object];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    if(MHFProtocolHasInstanceMethod(@protocol(NSFetchedResultsControllerDelegate), aSelector)){
        if([self.fetchedResultsControllerDelgate respondsToSelector:aSelector]){
            return self.fetchedResultsControllerDelgate;
        }
    }
    else if(MHFProtocolHasInstanceMethod(@protocol(UITableViewDataSource), aSelector)){
        if([self.tableDataSource respondsToSelector:aSelector]){
            return self.tableDataSource;
        }
    }
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - Fetched results controller

//- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
//    if(fetchedResultsController == _fetchedResultsController){
//        return;
//    }
//    if(_fetchedResultsController.delegate == self){
//        _fetchedResultsController.delegate = nil;
//    }
//    _fetchedResultsController = fetchedResultsController;
//    if(!fetchedResultsController.delegate){
//        fetchedResultsController.delegate = self;
//    }
//    if(!fetchedResultsController.fetchedObjects){
//        [fetchedResultsController performFetch:nil];
//    }
//    [self.tableView reloadData];
//}

#pragma mark Table Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    self.tableView = tableView;
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject<MCDTableViewCellObject> *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *cellIdentifier = @"Cell";
    if([object respondsToSelector:@selector(tableViewCellIdentifier)]){
        cellIdentifier = object.tableViewCellIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [self configureCell:cell withObject:object];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
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

#pragma mark - Fetch Controller Delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
    //self.selectedRowBeforeChanges = self.tableView.indexPathForSelectedRow;
    if([self.fetchedResultsControllerDelgate respondsToSelector:_cmd]){
        [self.fetchedResultsControllerDelgate controllerWillChangeContent:controller];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            self.sectionsCountChanged = YES;
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            self.sectionsCountChanged = YES;
            break;
        default:
            return;
    }
    if([self.fetchedResultsControllerDelgate respondsToSelector:_cmd]){
        [self.fetchedResultsControllerDelgate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
        {
            // Hardest thing is the object has already been deleted from teh detail fetch controller.
            // We can hack it to work with swiping or editing.
            // But if not editing and its deleted in background it gets messy.
            
            //            if([indexPath isEqual:self.selectedRowOfDetailItem]){
            //                self.selectionPathOfDeletedRow = indexPath;
            //            }
            if([indexPath isEqual:tableView.indexPathForSelectedRow]){
                
            }
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:object];
            break;
        case NSFetchedResultsChangeMove:
            if(self.sectionsCountChanged || indexPath.section != newIndexPath.section){
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            else{
                [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:object];
                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            }
            break;
    }
    if([self.fetchedResultsControllerDelgate respondsToSelector:_cmd]){
        [self.fetchedResultsControllerDelgate controller:controller didChangeObject:object atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    self.sectionsCountChanged = NO;
    //self.selectedRowBeforeChanges = nil;
    if([self.fetchedResultsControllerDelgate respondsToSelector:_cmd]){
        [self.fetchedResultsControllerDelgate controllerDidChangeContent:controller];
    }
    //    NSIndexPath *indexPath = self.selectionPathOfDeletedRow;
    //    if(indexPath){
    //        self.selectionPathOfDeletedRow = nil;
    //        if(self.splitViewController.isCollapsed){ // fix
    //            //self.selectedObject = nil; // what's this for?
    //            [self.navigationController popToViewController:self animated:YES];
    //        }
    //        else{
    //            [self performSelector:@selector(showObjectNearIndexPath:) withObject:indexPath afterDelay:0];
    //        }
    //    }
}

#pragma mark - Restoration

// on encode it asks for first and selected. On restore it asks for first so maybe checks ID.
- (nullable NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)idx inView:(UIView *)view{
    //NSAssert(self.fetchedTableDataSource.fetchedResultsController.fetchedObjects, @"modelIdentifierForElementAtIndexPath requires fetchedObjects");
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:idx];
    return object.objectID.URIRepresentation.absoluteString;
}

- (nullable NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view{
    NSURL *objectURI = [NSURL URLWithString:identifier];
    //  NSAssert(self.managedObjectContext, @"indexPathForElementWithModelIdentifier requires a context");
    NSManagedObject *object = [self.fetchedResultsController.managedObjectContext mcd_objectWithURI:objectURI];
    //[self.tableView reloadData];
    //  NSAssert(self.fetchedTableDataSource.fetchedResultsController.fetchedObjects, @"indexPathForElementWithModelIdentifier requires fetchedObjects");
    return [self.fetchedResultsController indexPathForObject:object];
}

@end
