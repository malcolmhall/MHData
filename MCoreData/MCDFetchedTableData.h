//
//  MCDFetchedTableData.h
//  MCoreData
//
//  Created by Malcolm Hall on 06/12/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class MCDManagedObjectTableViewCell;

@protocol MCDFetchedTableDataDelegate;

// rename to MCDTableViewFetchController because contains the deselect method and uses a delegate.
@interface MCDFetchedTableData<ResultType:id<NSFetchRequestResult>> : NSObject

- (instancetype)initWithTableView:(UITableView *)tableView;

@property (weak, nonatomic, readonly) UITableView *tableView;

// Set this to make it work, and the delegate is automatically set to this view controller.
// setting reloads the table but does not fetch.
@property (strong, nonatomic, nullable) NSFetchedResultsController<ResultType> *fetchedResultsController;

@property (nonatomic, weak, nullable) id<MCDFetchedTableDataDelegate> delegate;

// performs fetch and reloads the table, useful after changing the sort descriptor on the fetch request.
- (void)fetchAndReloadData;

//- (NSInteger)numberOfObjectsInFetchedSection:(NSInteger)section;

//- (NSInteger)numberOfSections;

//- (UITableViewCell *)cellForRowAtTableViewIndexPath:(NSIndexPath *)indexPath;

//- (BOOL)canEditRowAtTableViewIndexPath:(NSIndexPath *)indexPath;

//- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtTableViewIndexPath:(NSIndexPath *)indexPath;

- (void)deselectRowForObject:(ResultType)object animated:(BOOL)animated;

- (ResultType)objectAtTableIndexPath:(NSIndexPath *)indexPath;

- (NSIndexPath *)tableIndexPathForObject:(ResultType)object;

@end

@protocol MCDFetchedTableDataDelegate <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@optional

// default implementation gets the section info name for the object.
- (NSString *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData sectionHeaderTitleForObject:(id)object;

// simply supply the identifier of a result cell subclass and one will be dequed and the fetched object set on it.
//- (NSString *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedCellIdentifierForObject:(id)object;

// alternatively supply a result cell, e.g. by dequeing and configuring its appearance, then fetched object will be set on it.
// This method supersedes -fetchedTableData:fetchedCellIdentifierForObject: if return value is non-nil
//- (MCDManagedObjectTableViewCell *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedCellForObject:(id)object;

// alternatively create or dequeue a cell and fully configure it by setting the fetched object on it yourself.
// This method supersedes -fetchedTableData:resultCellForObject: if return value is non-nil
- (UITableViewCell *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData cellForObject:(id)object;

- (BOOL)fetchedTableData:(MCDFetchedTableData *)fetchedTableData canEditRowForObject:(id)object;

- (void)fetchedTableData:(MCDFetchedTableData *)fetchedTableData commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(id)object;
- (void)fetchedTableData:(MCDFetchedTableData *)fetchedTableData didSelectRowForObject:(id)object;
- (void)fetchedTableData:(MCDFetchedTableData *)fetchedTableData didDeselectRowForObject:(id)object;
// supercedes tableView:didEndEditingRowAtIndexPath:
//- (void)fetchedTableData:(MCDFetchedTableData *)fetchedTableData didEndEditingRowForObject:(id)object;
// supercedes tableView:shouldHighlightRowAtIndexPath:
- (BOOL)fetchedTableData:(MCDFetchedTableData *)fetchedTableData shouldHighlightRowForObject:(id)object;

#ifdef __IPHONE_11_0
- (nullable UISwipeActionsConfiguration *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData trailingSwipeActionsConfigurationForObject:(id)object API_AVAILABLE(ios(11.0)) API_UNAVAILABLE(tvos);
#endif

// Overriding the fetchedTableData methods.

// Changed to optional. If NSNotFound is returned the number of rows will be from the fetchedResultsController.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Changed to optional. If nil is returned the fetchedTableData cell methods will be called.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

// Translating

// Both must be implemented for section translating.
// return NSNotFound for invalid, i.e. a section that cannot be translated to a fetched section.
- (NSInteger)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedSectionForTableSection:(NSInteger)tableSection;
// return NSNotFound for invalid
- (NSInteger)fetchedTableData:(MCDFetchedTableData *)fetchedTableData tableSectionForFetchedSection:(NSInteger)fetchedSection;

// Both must be implemented for row translating and can call above 2 methods if section translating is also required.
//// return nil if invalid
- (nullable NSIndexPath *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData fetchedIndexPathForTableIndexPath:(NSIndexPath *)indexPath;
//// return nil if invalid
- (nullable NSIndexPath *)fetchedTableData:(MCDFetchedTableData *)fetchedTableData tableIndexPathForFetchedIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
