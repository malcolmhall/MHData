//
//  MCDFetchedResultsTableViewController.m
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 MAlcolm Hall. All rights reserved.
//

#import "MCDFetchedTableViewDataSource.h"

//static NSString * const kDefaultmessageWhenNoRows = @"There is no data available to display";
//static void * const kMCDFetchedResultsTableViewControllerKVOContext = (void *)&kMCDFetchedResultsTableViewControllerKVOContext;

@interface MCDFetchedTableViewDataSource()
@property (nonatomic, assign) BOOL sectionsCountChanged;
@end

@implementation MCDFetchedTableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView{
    self = [super init];
    if (self) {
        _tableView = tableView;
    }
    return self;
}

//- (void)viewDidLoad{
//    [super viewDidLoad];
//    self.fetchedTableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
//    self.fetchedTableData.delegate = self;
//}

//- (MCDFetchedTableData *)fetchedTableData{
//    if(!_fetchedTableData){
//        _fetchedTableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
//        _fetchedTableData.delegate = self;
//    }
//    return _fetchedTableData;
//}

//- (void)setTableView:(UITableView *)tableView{
//    if(tableView == _tableView){
//        return;
//    }
//    if(_tableView.dataSource == self){
//        _tableView.dataSource = nil;
//    }
//    _tableView = tableView;
//    if(!tableView.dataSource){
//        tableView.dataSource = self;
//    }
//}

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
}

//- (void)viewWillAppear:(BOOL)animated{
//    // perform a fetch if one hasn't been
//    if(!self.fetchedResultsController.fetchedObjects){
//        [self.fetchedResultsController performFetch:nil];
//    }
//    [super viewWillAppear:animated]; // reloads table if there are currently no sections
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

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

- (void)scrollToObject:(id)object{
    NSIndexPath *indexPath = [self.fetchedResultsController indexPathForObject:object];
    //NSManagedObjectContext *context = self.fetchedResultsController.managedObjectContext;
    //indexPath = [self indexPathForFolderInTableViewFromFetchedResultsControllerIndexPath:indexPath managedObjectContext:context];
    if(indexPath){
        if(![self.tableView.indexPathsForVisibleRows containsObject:indexPath]){
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }
}

@end
