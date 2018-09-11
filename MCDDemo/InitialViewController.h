//
//  InitialViewController.h
//  MCDDemo
//
//  Created by Malcolm Hall on 09/08/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCoreData/MCoreData.h>
#import "MCoreDataDemo+CoreDataModel.h"
//#import "DetailViewController.h"

@class MasterViewController;

@interface InitialViewController : MCDFetchedTableViewController <UIDataSourceModelAssociation>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) MasterViewController *masterViewController;

@property (strong, nonatomic) NSPersistentContainer *persistentContainer;

@end
