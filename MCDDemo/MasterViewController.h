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

@class DetailViewController, EventTableViewData;

@interface MasterViewController : MCDFetchedTableViewController  // UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) MCDNSPersistentContainer *persistentContainer;
//@property (strong, nonatomic) EventTableViewData *eventData;

@property (strong, nonatomic) id fetchItem;

@end

