//
//  MCDFetchedTableDataSource.h
//  MCoreData
//
//  Created by Malcolm Hall on 15/09/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <MHFoundation/MHFoundation.h>
@import CoreData;
@import UIKit;
#import <MCoreData/MCDTableViewCellObject.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FetchedTableDataSourceDelegate;

@interface MCDFetchedTableDataSource<CellObject : NSManagedObject<MCDTableViewCellObject> *> : NSObject <UITableViewDataSource, NSFetchedResultsControllerDelegate>

//- (instancetype)initWithTableView:(UITableView *)tableView;

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController tableView:(UITableView *)tableView;

@property (nonatomic, assign) id<FetchedTableDataSourceDelegate> delgate;

@property (nonatomic, assign) id<NSFetchedResultsControllerDelegate> fetchedResultsControllerDelgate;

//@property (strong, nonatomic) NSFetchedResultsController<CellObject> *fetchedResultsController;

@property (assign, nonatomic, readonly) NSFetchedResultsController<CellObject> *fetchedResultsController;

@property (strong, nonatomic, readonly) UITableView *tableView;

@property (nonatomic, assign) id<UITableViewDataSource> tableDataSource;

@end

@protocol FetchedTableDataSourceDelegate <NSObject>

@optional

//- (void)updateForFetchedDataSource:(MCDFetchedTableDataSource *)fetchedDataSource;

- (void)fetchedTableDataSource:(MCDFetchedTableDataSource *)fetchedTableDataSource configureCell:(UITableViewCell *)cell withObject:(NSManagedObject<MCDTableViewCellObject> *)object;

@end

NS_ASSUME_NONNULL_END
