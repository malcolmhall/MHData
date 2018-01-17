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
@synthesize tableData = _tableData;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableData = [MCDFetchedTableData.alloc initWithTableView:self.tableView];
    self.tableData.delegate = self;
    self.tableData.tableDataSource = self;
    self.tableData.tableDelegate = self;
}

- (void)setTableData:(MCDFetchedTableData *)tableData{
    if(_tableData != tableData){
        if(_tableData.delegate == self){
            _tableData.delegate = nil;
        }
        _tableData = tableData;
        if(!tableData.delegate){
            tableData.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    // perform a fetch if one hasn't been
    if(!self.tableData.fetchedResultsController.fetchedObjects){
        [self.tableData.fetchedResultsController performFetch:nil];
    }
    [super viewWillAppear:animated]; // reloads table if there are currently no sections
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return NSNotFound;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return NSNotFound;
//}

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
