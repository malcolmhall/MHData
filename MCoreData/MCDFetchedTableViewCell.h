//
//  MCDFetchedTableViewCell.h
//  MCoreData
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <MHFoundation/MHFoundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDFetchedTableViewCell<ResultType:id<NSFetchRequestResult>> : UITableViewCell <MHFObserverDelegate>

@property (strong, nonatomic, nullable) ResultType fetchedObject; // rename to either cellObject or resultObject

@property (strong, nonatomic) MHFObserver *observerForUpdatingViews;

// call to have update views for current object called and it'll only do it if visible.
- (void)updateViewsForCurrentObjectIfNecessary;

// overrides

// The default implementation unsets needsToUpdateViews. Is called for all keyPaths being observed.
- (void)updateViewsForCurrentObject NS_REQUIRES_SUPER;

// the default implementation adds observer for the keyPathsForUpdatingViews.
//- (void)startObservingCurrentObject NS_REQUIRES_SUPER;

// the default implementation removes observer for the keyPathsForUpdatingViews.
//- (void)stopObservingCurrentObject NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
