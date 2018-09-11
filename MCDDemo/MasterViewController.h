//
//  MasterViewController.h
//  MCoreDataDemo
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MCoreData/MCoreData.h>
#import "MCoreDataDemo+CoreDataModel.h"
#import "DetailViewController.h"

@class EventTableViewData;

extern NSString * const MasterViewControllerDetailObjectKey;

@interface MasterViewController : MCDFetchedTableViewController <UIDataSourceModelAssociation, UIViewControllerRestoration> // UITableViewController <NSFetchedResultsControllerDelegate>

//@property (strong, nonatomic) DetailViewController *shownViewController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) MCDNSPersistentContainer *persistentContainer;
//@property (strong, nonatomic) EventTableViewData *eventData;

@property (strong, nonatomic) Venue *masterItem;
- (void)setMasterItem:(NSManagedObject *)masterItem deleteCache:(BOOL)deleteCache;

@end

