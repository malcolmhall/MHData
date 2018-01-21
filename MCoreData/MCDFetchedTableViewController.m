//
//  MCDFetchedResultsTableViewController.m
//  MCoreData
//
//  Created by Malcolm Hall on 7/12/13.
//  Copyright (c) 2013 MAlcolm Hall. All rights reserved.
//

#import "MCDFetchedTableViewController.h"

//static NSString * const kDefaultmessageWhenNoRows = @"There is no data available to display";
//static void * const kMCDFetchedResultsTableViewControllerKVOContext = (void *)&kMCDFetchedResultsTableViewControllerKVOContext;

@implementation MCDFetchedTableViewController{
    //NSString *_messageWhenNoRows;
}
@synthesize fetchedTableData = _fetchedTableData;

//- (void)viewDidLoad{
//    [super viewDidLoad];
//    self.fetchedTableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
//    self.fetchedTableData.delegate = self;
//}

- (MCDFetchedTableData *)fetchedTableData{
    if(!_fetchedTableData){
        _fetchedTableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
        _fetchedTableData.delegate = self;
    }
    return _fetchedTableData;
}

- (void)setFetchedDataSource:(MCDFetchedTableData *)fetchedTableData{
    if(_fetchedTableData != fetchedTableData){
        if(_fetchedTableData.delegate == self){
            _fetchedTableData.delegate = nil;
        }
        _fetchedTableData = fetchedTableData;
        if(!fetchedTableData.delegate){
            fetchedTableData.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    // perform a fetch if one hasn't been
    if(!self.fetchedTableData.fetchedResultsController.fetchedObjects){
        [self.fetchedTableData.fetchedResultsController performFetch:nil];
    }
    [super viewWillAppear:animated]; // reloads table if there are currently no sections
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return NSNotFound;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return NSNotFound;
}

//- (NSString *)messageWhenNoRows{
//    if(!_messageWhenNoRows){
//        _messageWhenNoRows = kDefaultmessageWhenNoRows;
//    }
//    return _messageWhenNoRows;
//}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    id object = [self objectAtTableIndexPath:indexPath];
//    if(!object){
//        return;
//    }
//    [self didSelectObject:object];
//}
//
//- (void)didSelectObject:(id)object{
//    return;
//}






@end
