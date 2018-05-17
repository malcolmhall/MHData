//
//  EventTableViewCell.h
//  MCDDemo
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCoreData/MCoreData.h>
#import "MCoreDataDemo+CoreDataModel.h"

@interface EventTableViewCell : MCDTableViewCell

@property (strong, nonatomic) Event *event;

@end
