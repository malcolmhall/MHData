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

@interface MCDFetchedTableViewCell<ResultType:id<NSFetchRequestResult>> : UITableViewCell

@property (strong, nonatomic) ResultType fetchedObject; // rename to either cellObject or resultObject

// when these keys change in the resultObject updateViews is called
@property (strong, nonatomic) NSArray<NSString *> *objectKeyPathsForViews;

// call to have update views for current object called and it'll only do it if visible.
- (void)updateViewsForCurrentObjectIfNecessary;

// overrides

// the default implementation unsets needsToUpdateViews.
- (void)updateViewsForCurrentObject NS_REQUIRES_SUPER;

// the default implementation adds observer for the keyPathsForUpdatingViews.
- (void)startObservingCurrentObject NS_REQUIRES_SUPER;

// the default implementation removes observer for the keyPathsForUpdatingViews.
- (void)stopObservingCurrentObject NS_REQUIRES_SUPER;

@end
