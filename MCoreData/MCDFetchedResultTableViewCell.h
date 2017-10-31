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

@interface MCDFetchedResultTableViewCell<ResultType:id<NSFetchRequestResult>> : UITableViewCell

@property (strong, nonatomic) ResultType fetchedObject;

// when these keys change in the resultObject updateViews is called
@property (strong, nonatomic) NSArray<NSString *> *objectKeyPathsForViews;

// the default implementation unsets needsToUpdateViews.
- (void)updateViewsForCurrentObject NS_REQUIRES_SUPER;

// the default implementation adds observer for the keyPathsForUpdatingViews.
- (void)startObservingCurrentObject NS_REQUIRES_SUPER;

// the default implementation removes observer for the keyPathsForUpdatingViews.
- (void)stopObservingCurrentObject NS_REQUIRES_SUPER;

@end
