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
@synthesize fetchedDataSource = _fetchedDataSource;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.fetchedDataSource = [MCDFetchedDataSource.alloc initWithTableView:self.tableView];
    self.fetchedDataSource.delegate = self;
}

- (void)setFetchedDataSource:(MCDFetchedDataSource *)fetchedDataSource{
    if(_fetchedDataSource != fetchedDataSource){
        if(_fetchedDataSource.delegate == self){
            _fetchedDataSource.delegate = nil;
        }
        _fetchedDataSource = fetchedDataSource;
        if(!fetchedDataSource.delegate){
            fetchedDataSource.delegate = self;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    // perform a fetch if one hasn't been
    if(!self.fetchedDataSource.fetchedResultsController.fetchedObjects){
        [self.fetchedDataSource.fetchedResultsController performFetch:nil];
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
