//
//  MCDManagedObjectTableViewCell.h
//  MCoreData
//
//  Created by Malcolm Hall on 27/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

//MCDATA_EXTERN void * const MCDManagedObjectTableViewCellUpdpateViewsContext;

@interface MCDManagedObjectTableViewCell : UITableViewCell

// needs to be retained to prevent being turned into a fault
@property (nullable, strong, nonatomic) NSManagedObject *object;

@property (nonatomic, strong) NSArray<NSString *> *viewedKeys;

// overrides

// update views from the object's properties
- (void)updateViewsFromCurrentObject NS_REQUIRES_SUPER;
// calls update if on screen otherwise sets a flag and then updates when comes on screen.
- (void)updateViewsFromCurrentObjectIfNecessary NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
