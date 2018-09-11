//
//  DetailViewController.h
//  MCoreDataDemo
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCoreData/MCoreData.h>
#import "MCoreDataDemo+CoreDataModel.h"

extern NSString * const DetailViewControllerDetailObjectKey;

@interface DetailViewController : UIViewController <UIViewControllerRestoration>

@property (strong, nonatomic) Event *event;
//@property (strong, nonatomic, readonly) Event *detailItem;
//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
//@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

