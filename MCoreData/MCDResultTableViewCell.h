//
//  MCDFetchedTableViewCell.h
//  MCoreData
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

@interface MCDResultTableViewCell : UITableViewCell

@property (strong, nonatomic) NSManagedObject *resultObject;

// when these keys change in the resultObject updateViews is called
@property (strong, nonatomic) NSArray<NSString *> *keyPathsForUpdatingViews; // changing

- (void)updateViewsForCurrentResultObject NS_REQUIRES_SUPER;

@end
