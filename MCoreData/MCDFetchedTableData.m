//
//  MCDFetchedTableData.m
//  MCoreData
//
//  Created by Malcolm Hall on 06/12/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MCDFetchedTableData.h"
#import "MCDFetchedTableViewCell.h"
#import "NSFetchedResultsController+MCD.h"
#import <objc/runtime.h>

@interface MCDFetchedTableData()<NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL sectionsCountChanged;

@end

@implementation MCDFetchedTableData

- (instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

- (void)setDelegate:(id<MCDFetchedTableDataDelegate>)delegate{
    _delegate = delegate;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

BOOL isProtocolMethod(Protocol * protocol, SEL selector) {
    struct objc_method_description desc;
    desc = protocol_getMethodDescription(protocol, selector, NO, YES);
    if(desc.name){
        return YES;
    }
    desc = protocol_getMethodDescription(protocol, selector, YES, YES);
    if(desc.name){
        return YES;
    }
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector{
    if(isProtocolMethod(@protocol(UITableViewDelegate), aSelector)){
        return self.delegate;
    }
    else if(isProtocolMethod(@protocol(UITableViewDataSource), aSelector)){
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector{
    if([super respondsToSelector:aSelector]){
        return YES;
    }
    else if(isProtocolMethod(@protocol(UITableViewDelegate), aSelector)){
        return [self.delegate respondsToSelector:aSelector];
    }
    else if(isProtocolMethod(@protocol(UITableViewDataSource), aSelector)){
        return [self.delegate respondsToSelector:aSelector];
    }
    return NO;
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
    if(fetchedResultsController == _fetchedResultsController){
        return;
    }
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = fetchedResultsController;
    fetchedResultsController.delegate = self;
    [self.tableView reloadData];
}

- (void)fetchAndReloadData{
    [self.fetchedResultsController performFetch:nil];
    [self.tableView reloadData]; // if the frc has been fetched it will load in, if not or its nil it will empty the table
}

//- (NSInteger)numberOfSections{
//    return self.fetchedResultsController.sections.count;
//}

//- (NSInteger)numberOfObjectsInSection:(NSInteger)section{
//    if([self.delegate respondsToSelector:@selector(fetchedTableData:fetchedIndexPathForTableIndexPath:)]){
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
//        indexPath = [self.delegate fetchedTableData:self fetchedIndexPathForTableIndexPath:indexPath];
//        section = indexPath.section;
//    }
    //if(section >= 0 && section < self.fetchedResultsController.sections.count){
    
    //}
//}

//- (UITableViewCell *)cellForRowAtTableViewIndexPath:(NSIndexPath *)indexPath{
//
//}

// default is YES but since we don't have an object we'll return NO in that case since the edit can't be committed anyways.
//- (BOOL)canEditRowAtTableViewIndexPath:(NSIndexPath *)indexPath{
//
//}

//- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtTableViewIndexPath:(NSIndexPath *)indexPath{
//
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if([self.delegate respondsToSelector:@selector(numberOfSectionsInTableView:)]){
        NSInteger sections = [self.delegate numberOfSectionsInTableView:tableView];
        if(sections != 1){ // 1 is the default
            return sections;
        }
    }
    return self.fetchedResultsController.sections.count;

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
    //return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([self.delegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)]){ // because now optional.
        NSInteger rows = [self.delegate tableView:tableView numberOfRowsInSection:section];
        if(rows != NSNotFound){
            return rows;
        }
    }
    section = [self fetchedSectionForTableSection:section];
    if(section == NSNotFound){
        return 0;
    }
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)]){ // because now optional.
        UITableViewCell *cell = [self.delegate tableView:self.tableView cellForRowAtIndexPath:indexPath];
        if(cell){
            return cell;
        }
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return nil; // or exception because if it isnt an object index then we should have got a cell.
    }
    if([self.delegate respondsToSelector:@selector(fetchedTableData:cellForObject:)]){
        UITableViewCell *cell = [self.delegate fetchedTableData:self cellForObject:object];
        if(cell){
            return cell;
        }
    }
    if([self.delegate respondsToSelector:@selector(fetchedTableData:fetchedCellForObject:)]){
        MCDFetchedTableViewCell *fetchedCell = [self.delegate fetchedTableData:self fetchedCellForObject:object];
        if(fetchedCell){
            fetchedCell.fetchedObject = object;
            return fetchedCell;
        }
    }
    if([self.delegate respondsToSelector:@selector(fetchedTableData:fetchedCellIdentifierForObject:)]){
        NSString *identifier = [self.delegate fetchedTableData:self fetchedCellIdentifierForObject:object];
        if(identifier){
            UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                [NSException raise:NSInvalidArgumentException format:@"fetchedCellIdentifierForObject returned an identifier %@ but we failed to dequeue a cell", identifier];
            }
            else if(![cell isKindOfClass:MCDFetchedTableViewCell.class]){
                [NSException raise:NSInvalidArgumentException format:@"fetchedCellIdentifierForObject returned an identifier %@ and we dequeued a cell %@ but it is not a subclass of %@", identifier, NSStringFromClass(cell.class), NSStringFromClass(MCDFetchedTableViewCell.class)];
            }
            MCDFetchedTableViewCell *fetchedCell = (MCDFetchedTableViewCell *)cell;
            fetchedCell.fetchedObject = object;
            return fetchedCell;
        }
    }
    // Some magic as a last resort
    if([object isKindOfClass:NSManagedObject.class]){
        NSManagedObject *managedObject = (NSManagedObject *)object;
        NSString *identifier = managedObject.entity.name;
        UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
        if(![cell isKindOfClass:MCDFetchedTableViewCell.class]){
            [NSException raise:NSInvalidArgumentException format:@"Cell was dequeued using entity name %@ as identifier but the cell %@ was not a subclass of %@", identifier, NSStringFromClass(cell.class), NSStringFromClass(MCDFetchedTableViewCell.class)];
        }
        MCDFetchedTableViewCell *fetchedCell = (MCDFetchedTableViewCell *)cell;
        fetchedCell.fetchedObject = object;
        return fetchedCell;
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:canEditRowAtIndexPath:)]){
        BOOL canEdit = [self.delegate tableView:self.tableView canEditRowAtIndexPath:indexPath];
        if(!canEdit){
            return NO;
        }
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return YES;
    }
    if([self.delegate respondsToSelector:@selector(fetchedTableData:canEditRowForObject:)]){
        // Return NO if you do not want the specified item to be editable.
        return [self.delegate fetchedTableData:self canEditRowForObject:object];
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:commitEditingStyle:forRowAtIndexPath:)]){
        [self.delegate tableView:self.tableView commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return;
    }
    else if([self.delegate respondsToSelector:@selector(fetchedTableData:commitEditingStyle:forObject:)]){
        [self.delegate fetchedTableData:self commitEditingStyle:editingStyle forObject:object];
    }
}
    
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(tableView:canMoveRowAtIndexPath:)]){
        BOOL canMove = [self.delegate tableView:self.tableView canMoveRowAtIndexPath:indexPath];
        if(canMove){
            return YES;
        }
    }
    // cannot reorder sorted fetch controller
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if([self.delegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)]){
        NSString *title = [self.delegate tableView:tableView titleForHeaderInSection:section];
        if(title){
            return title;
        }
    }
    section = [self fetchedSectionForTableSection:section];
    if(section == NSNotFound){
        return nil;
    }
    id <NSFetchedResultsSectionInfo> sectionInfo = self.fetchedResultsController.sections[section];
    // it is possible to be asked for a title to a section that has no objects.
    //    if(!sectionInfo.numberOfObjects){
    //        return nil;
    //    }
    id object = sectionInfo.objects.firstObject;
    if(!object){
        return nil;
    }
    else if([self.delegate respondsToSelector:@selector(fetchedTableData:sectionHeaderTitleForObject:)]){
        // we allow returning nil from this to override default behavior
        return [self.delegate fetchedTableData:self sectionHeaderTitleForObject:object];
    }
    else if([object isKindOfClass:NSManagedObject.class]){
        // some magic as last resort
        NSManagedObject *managedObject = (NSManagedObject *)object;
        return managedObject.entity.name;
    }
    return nil;
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//    return self.fetchedResultsController.sectionIndexTitles;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//    return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
//}


#pragma mark - UITableViewDelegate

#ifdef __IPHONE_11_0

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(nonnull NSIndexPath *)indexPath API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
    if([self.delegate respondsToSelector:@selector(tableView:trailingSwipeActionsConfigurationForRowAtIndexPath:)]){
        UISwipeActionsConfiguration * config = [self.delegate tableView:tableView trailingSwipeActionsConfigurationForRowAtIndexPath:indexPath];
        if(config){
            return config;
        }
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return nil;
    }
    if([self.delegate respondsToSelector:@selector(fetchedTableData:trailingSwipeActionsConfigurationForObject:)]){
       return [self.delegate fetchedTableData:self trailingSwipeActionsConfigurationForObject:object];
    }
    return nil;
}

#endif

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return;
    }
    else if([self.delegate respondsToSelector:@selector(fetchedTableData:didSelectRowForObject:)]){
        [self.delegate fetchedTableData:self didSelectRowForObject:object];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(tableView:didDeselectRowAtIndexPath:)]){
        [self.delegate tableView:tableView didDeselectRowAtIndexPath:indexPath];
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return;
    }
    else if([self.delegate respondsToSelector:@selector(fetchedTableData:didDeselectRowForObject:)]){
        [self.delegate fetchedTableData:self didDeselectRowForObject:object];
    }
}

// this is called after a swipe to delete but not a tap to delete. So in this case the object is nil if it was deleted.
// bad
//- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
//    id object = [self objectAtTableIndexPath:indexPath];
//    if(!object){
//        return;
//    }
//    else if([self.delegate respondsToSelector:@selector(fetchedTableData:didEndEditingRowForObject:)]){
//        [self.delegate fetchedTableData:self didEndEditingRowForObject:object];
//    }
//    else if([self.delegate respondsToSelector:@selector(tableView:didEndEditingRowAtIndexPath:)]){
//        [self.delegate tableView:tableView didEndEditingRowAtIndexPath:indexPath];
//    }
//}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]){
        BOOL shouldHighlight = [self.delegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
        if(!shouldHighlight){
            return NO;
        }
    }
    id object = [self objectAtTableIndexPath:indexPath];
    if(!object){
        return YES;
    }
    else if([self.delegate respondsToSelector:@selector(fetchedTableData:shouldHighlightRowForObject:)]){
        return [self.delegate fetchedTableData:self shouldHighlightRowForObject:object];
    }
    return YES;
}

#pragma mark - NSFetchedResultsControllerDelegate
    
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
//    if([self.delegate respondsToSelector:@selector(controllerWillChangeContent:)]){
//        [self.delegate controllerWillChangeContent:controller];
//    }
    NSLog(@"Begin Updates");
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
//    if([self.delegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)]){
//        [self.delegate controller:controller didChangeSection:sectionInfo atIndex:sectionIndex forChangeType:type];
//    }
    sectionIndex = [self tableSectionForFetchedSection:sectionIndex];
    
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
    indexPath = [self tableIndexPathForFetchedIndexPath:indexPath];
    newIndexPath = [self tableIndexPathForFetchedIndexPath:newIndexPath];
    
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
    if([self.delegate respondsToSelector:@selector(controllerDidChangeContent:)]){
        [self controllerDidChangeContent:controller];
    }
    if(controller != self.fetchedResultsController){
        return;
    }
    self.sectionsCountChanged = NO;
    NSLog(@"End Updates");
    [self.tableView endUpdates];
}

//- (NSString *)sectionHeaderTitleForObject:(id<NSFetchRequestResult>)object{
//    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
//    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:indexPath.section];
//    return sectionInfo.name;
//}

//- (BOOL)shouldHighlightObject:(id<NSFetchRequestResult>)resultObject{
//    return YES;
//}
//
//- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(id<NSFetchRequestResult>)object{
//    return;
//}

// default to yes to match normal.
//- (BOOL)canEditObject:(id)object{
//    return YES;
//}
//
//- (UITableViewCell *)cellForObject:(id<NSFetchRequestResult>)object{
//    return nil;
//}
//
//- (MCDFetchedTableViewCell *)resultCellForObject:(id<NSFetchRequestResult>)object{
//    return nil;
//}
//
//- (nullable UISwipeActionsConfiguration *)trailingSwipeActionsConfigurationForObject:(id<NSFetchRequestResult>)object API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos){
//    return nil;
//}

#pragma Table to Fetched

- (NSInteger)fetchedSectionForTableSection:(NSInteger)tableSection{
    if([self.delegate respondsToSelector:@selector(fetchedTableData:fetchedSectionForTableSection:)]){
        return [self.delegate fetchedTableData:self fetchedSectionForTableSection:tableSection];
    }
    return tableSection;
}

- (NSIndexPath *)fetchedIndexPathForTableIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(fetchedTableData:fetchedIndexPathForTableIndexPath:)]){
        return [self.delegate fetchedTableData:self fetchedIndexPathForTableIndexPath:indexPath];
    }
    NSInteger section = [self fetchedSectionForTableSection:indexPath.section];
    if(section == NSNotFound){
        return nil;
    }
    return [NSIndexPath indexPathForRow:indexPath.row inSection:section];
}

- (id<NSFetchRequestResult>)objectAtTableIndexPath:(NSIndexPath *)indexPath{
    indexPath = [self fetchedIndexPathForTableIndexPath:indexPath];
    if(!indexPath){
        return nil;
    }
    // object might be deleted, e.g. if didEndEditing is implelemented
    //    if(![self.fetchedResultsController mcd_isValidIndexPath:indexPath]){
    //        return nil;
    //    }
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}



#pragma Fetched to Table

- (NSInteger)tableSectionForFetchedSection:(NSInteger)fetchedSection{
    if([self.delegate respondsToSelector:@selector(fetchedTableData:tableSectionForFetchedSection:)]){
        return [self.delegate fetchedTableData:self tableSectionForFetchedSection:fetchedSection];
    }
    return fetchedSection;
}

- (NSIndexPath *)tableIndexPathForFetchedIndexPath:(NSIndexPath *)indexPath{
    if([self.delegate respondsToSelector:@selector(fetchedTableData:tableIndexPathForFetchedIndexPath:)]){
        return [self.delegate fetchedTableData:self tableIndexPathForFetchedIndexPath:indexPath];
    }
    NSInteger section = [self tableSectionForFetchedSection:indexPath.section];
    if(section == NSNotFound){
        return nil;
    }
    return [NSIndexPath indexPathForRow:indexPath.row inSection:section];
}

- (NSIndexPath *)tableIndexPathForObject:(id)object{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
    if(!indexPath){
        return nil;
    }
    return [self tableIndexPathForFetchedIndexPath:indexPath];
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

- (void)deselectRowForObject:(id)object animated:(BOOL)animated{
    NSIndexPath *indexPath = [self tableIndexPathForObject:object];
    [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
}

- (void)dealloc{
    _tableView = nil;
    self.fetchedResultsController = nil;
}


@end
