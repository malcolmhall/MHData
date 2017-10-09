//
//  MCDFetchedResultsViewController.m
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 MAlcolm Hall. All rights reserved.
//

#import "MCDFetchedResultsViewController.h"

static NSString * const kDefaultCellReuseIdentifier = @"Cell";
static NSString * const kDefaultmessageWhenNoRows = @"There is no data available to display";

@implementation MCDFetchedResultsViewController{
    NSString *_cellReuseIdentifier;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    // set the default cell reuse identifer here so we can use it internally without copying.
    //self.cellReuseIdentifier = kDefaultCellReuseIdentifier;
    self.messageWhenNoRows = kDefaultmessageWhenNoRows;
}

- (NSString *)cellReuseIdentifier{
    if(!_cellReuseIdentifier){
        _cellReuseIdentifier = kDefaultCellReuseIdentifier;
    }
    return _cellReuseIdentifier;
}

- (void)setCellReuseIdentifier:(NSString *)cellReuseIdentifier{
    if(!cellReuseIdentifier){
        cellReuseIdentifier = kDefaultCellReuseIdentifier;
    }
    _cellReuseIdentifier = cellReuseIdentifier.copy;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
    if(fetchedResultsController == _fetchedResultsController){
        return;
    }
    _fetchedResultsController = fetchedResultsController;
    if(fetchedResultsController){
        // ensure we are the delegate
        fetchedResultsController.delegate = self;
        NSError *error = nil;
        if (![fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
    [self.tableView reloadData];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = self.fetchedResultsController.sections.count;
    // when set to nil they dont want this feature.
    if(!self.messageWhenNoRows){
        return numberOfSections;
    }
    // calc total rows across all sections.
    NSInteger totalNumberOfRows = 0;
    for(NSInteger i = 0; i < numberOfSections; i++){
        totalNumberOfRows += [self tableView:tableView numberOfRowsInSection:i];
    }
    if (totalNumberOfRows > 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.backgroundView = nil;
    } else {
        // Display a message when the table is empty (doesn't work if multiple sections)
        UILabel *messageLabel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = self.messageWhenNoRows;
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        tableView.backgroundView = messageLabel;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
    if(!cell){
        //todo cell style default might not be right, untested
        cell = [UITableViewCell.alloc initWithStyle:self.defaultCellStyle reuseIdentifier:self.cellReuseIdentifier];
    }
    NSManagedObject *object = [self objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:object];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell withObject:(NSManagedObject *)object{
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    NSManagedObject *object = [self objectAtIndexPath:indexPath];
    return [self canEditObject:object];
}

//default to yes to match normal.
- (BOOL)canEditObject:(NSManagedObject*)managedObject{
    return YES;
}

- (NSManagedObject *)objectAtIndexPath:(NSIndexPath *)indexPath{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)deleteObject:(NSManagedObject*)managedObject{
    NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
    [context deleteObject:managedObject];
    NSError *error;
    if(![context save:&error]){
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(NSManagedObject *)object{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteObject:object];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self commitEditingStyle:editingStyle forObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.fetchedResultsController.sections.count > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
        return sectionInfo.name;
    } else
        return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

/*
 
 - (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
 return YES;
 }
 
 - (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
 return action == @selector(copy:);
 }
 
 
 - (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 MyApp *myApp = (MyApp*) [self.fetchedResultsController objectAtIndexPath:indexPath];
 [UIPasteboard generalPasteboard].string = clip.text;
 }
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(controller != self.fetchedResultsController){
        return;
    }
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
            break;
        case NSFetchedResultsChangeDelete:
            NSLog(@"Section Delete");
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"Section Move");
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Section Update");
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if(controller != self.fetchedResultsController){
        return;
    }
    UITableView *tableView = self.tableView;

    switch(type) {
        case NSFetchedResultsChangeInsert:
            NSLog(@"Insert %@", newIndexPath);
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            NSLog(@"Delete %@", indexPath);
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            NSLog(@"Move %@ to %@", indexPath, newIndexPath);
            // Can't use the tableView move method becasue its animation does not play with section inserts/deletes.
            // Also if we used move would need to update the cell manually which might use the wrong index.
            // Even if old and new indices are the same we still need to call the methods.
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            NSLog(@"Update %@ to %@", indexPath, newIndexPath);
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(controller != self.fetchedResultsController){
        return;
    }
    NSLog(@"End Updates");
    [self.tableView endUpdates];
}

- (void)dealloc{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
}

@end
