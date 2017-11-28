//
//  MCDFetchedResultsTableViewController.m
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 MAlcolm Hall. All rights reserved.
//

#import "MCDFetchedResultsTableViewController.h"
#import "MCDFetchedResultTableViewCell.h"

//static NSString * const kDefaultmessageWhenNoRows = @"There is no data available to display";
static void * const kMCDFetchedResultsTableViewControllerKVOContext = (void *)&kMCDFetchedResultsTableViewControllerKVOContext;

@interface MCDFetchedResultsTableViewController()

@property (nonatomic) BOOL sectionsCountChanged;

@end

@implementation MCDFetchedResultsTableViewController{
    //NSString *_messageWhenNoRows;
}

- (void)fetchAndReloadData{
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
    if(fetchedResultsController == _fetchedResultsController){
        return;
    }
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    [self.tableView reloadData]; // if the frc has been fetched it will load in, if not or its nil it will empty the table.
}

- (void)viewWillAppear:(BOOL)animated{
    if(!self.fetchedResultsController.fetchedObjects){
        [self.fetchedResultsController performFetch:nil];
    }
    [super viewWillAppear:animated]; // reloads table if there are currently no sections
}

//- (NSString *)messageWhenNoRows{
//    if(!_messageWhenNoRows){
//        _messageWhenNoRows = kDefaultmessageWhenNoRows;
//    }
//    return _messageWhenNoRows;
//}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numberOfSections = self.fetchedResultsController.sections.count;
    
    // todo: should be checking the model rather than the result of the view
//    if(!self.messageWhenNoRows){
//        return numberOfSections;
//    }
//    // calc total rows across all sections.
//    NSInteger totalNumberOfRows = 0;
//    for(NSInteger i = 0; i < numberOfSections; i++){
//        totalNumberOfRows += [self tableView:tableView numberOfRowsInSection:i];
//    }
//    if (totalNumberOfRows > 0) {
//        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//        tableView.backgroundView = nil;
//    } else {
//        // Display a message when the table is empty (doesn't work if multiple sections)
//        UILabel *messageLabel = [UILabel.alloc initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
//
//        messageLabel.text = self.messageWhenNoRows;
//        messageLabel.numberOfLines = 0;
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
//        [messageLabel sizeToFit];
//
//        tableView.backgroundView = messageLabel;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    }
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [self fetchedResultsControllerIndexPathFromTableViewIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[indexPath.section];
    return sectionInfo.numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return nil;
    }
    UITableViewCell *cell = [self cellForObject:object];
    if(cell){
        return cell;
    }
    MCDFetchedResultTableViewCell *resultCell = [self resultCellForObject:object];
    if(!resultCell){
        NSString *identifier = [self resultCellIdentifierForObject:object];
        resultCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    if(![resultCell isKindOfClass:MCDFetchedResultTableViewCell.class]){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"cell was not a result cell" userInfo:nil];
    }
    resultCell.fetchedObject = object;
    return resultCell;
}

- (UITableViewCell *)cellForObject:(id<NSFetchRequestResult>)object{
    return nil;
}

- (NSString *)resultCellIdentifierForObject:(id<NSFetchRequestResult>)object{
    return nil;
}

- (MCDFetchedResultTableViewCell *)resultCellForObject:(id<NSFetchRequestResult>)object{
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return NO;
    }
    return [self canEditObject:object];
}

// default to yes to match normal.
- (BOOL)canEditObject:(id)object{
    return YES;
}

- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(id<NSFetchRequestResult>)object{
    return;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return;
    }
    return [self commitEditingStyle:editingStyle forObject:object];
}

#ifdef __IPHONE_11_0

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return nil;
    }
    return [self trailingSwipeActionsConfigurationForObject:object];
}

- (nullable UISwipeActionsConfiguration *)trailingSwipeActionsConfigurationForObject:(id<NSFetchRequestResult>)object API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    return nil;
}

#endif

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return nil;
    }
    return [self shouldHighlightObject:object];
}

- (BOOL)shouldHighlightObject:(id<NSFetchRequestResult>)resultObject{
    return YES;
}

// it is possible to be asked for t title to a section that has no objects.
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    if(!sectionInfo.numberOfObjects){
        return nil;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section]; // bug its using collection view indexPathForItem
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return nil;
    }
    return [self sectionHeaderTitleForObject:object];
}

- (NSString *)sectionHeaderTitleForObject:(id<NSFetchRequestResult>)object{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:indexPath.section];
    return sectionInfo.name;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id object = [self objectAtTableViewIndexPath:indexPath];
    if(!object){
        return;
    }
    [self didSelectObject:object];
}

- (void)didSelectObject:(id)object{
    return;
}

- (void)deselectObject:(id)object animated:(BOOL)animated{
    NSIndexPath *indexPath = [self tableViewIndexPathForObject:object];
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (NSIndexPath *)tableViewIndexPathForObject:(id)object{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
    return [self tableViewIndexPathFromFetchedResultsControllerIndexPath:indexPath];
}

- (id<NSFetchRequestResult>)objectAtTableViewIndexPath:(NSIndexPath *)indexPath{
    indexPath = [self fetchedResultsControllerIndexPathFromTableViewIndexPath:indexPath];
    if(indexPath.section >= self.fetchedResultsController.sections.count){
        return nil;
    }
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)fetchedResultsControllerIndexPathFromTableViewIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

- (NSIndexPath *)tableViewIndexPathFromFetchedResultsControllerIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}

/*
 
 - (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
 return YES;
 }
 
 - (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
 return action == @selector(copy:);
 }
 
 
 - (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 MyApp *myApp = (MyApp*) [self objectAtIndexPath:indexPath];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
    indexPath = [self tableViewIndexPathFromFetchedResultsControllerIndexPath:indexPath];
    sectionIndex = indexPath.section;
    
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

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if(controller != self.fetchedResultsController){
        return;
    }
    UITableView *tableView = self.tableView;
    indexPath = [self tableViewIndexPathFromFetchedResultsControllerIndexPath:indexPath];
    newIndexPath = [self tableViewIndexPathFromFetchedResultsControllerIndexPath:newIndexPath];
    
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
            if(!self.sectionsCountChanged && indexPath.section == newIndexPath.section){
                [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            }
            else{
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
        case NSFetchedResultsChangeUpdate:
            // Using KVO to optimise update of cells.
            //NSLog(@"Update %@ to %@", indexPath, newIndexPath);
            //[self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    self.sectionsCountChanged = NO;
    NSLog(@"End Updates");
    [self.tableView endUpdates];
}

- (void)dealloc{
    self.fetchedResultsController = nil;
}

@end
