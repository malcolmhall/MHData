//
//  MCDManagedObjectTableViewCell.h
//  MCoreData
//
//  Created by Malcolm Hall on 27/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDObjectViewer.h>

NS_ASSUME_NONNULL_BEGIN

//MCDATA_EXTERN void * const MCDManagedObjectTableViewCellUpdpateViewsContext;

@protocol MCDTableViewCellObject;

@interface MCDTableViewCell : UITableViewCell// <MCDObjectViewer>

//- (instancetype)initWithStyle:(UITableViewCellStyle)style;

// needs to be retained for KVO and also to prevent being turned into a fault.
@property (nullable, strong, nonatomic) NSManagedObject<MCDTableViewCellObject> *object;

//@property (nonatomic, strong) NSArray<NSString *> *viewedKeys;

// overrides

// update views from the object's properties
- (void)updateViewsFromCurrentObject NS_REQUIRES_SUPER;
// calls update if on screen otherwise sets a flag and then updates when comes on screen.
- (void)updateViewsFromCurrentObjectIfNecessary NS_REQUIRES_SUPER;

@end

@protocol MCDTableViewCellObject <NSObject>

// the keys of the object that are viewed in the cell. Update views will be called when their values change.
//+ (NSSet<NSString *> *)keyPathsForTableViewCell;
- (NSString *)titleForTableViewCell;
@optional
- (NSString *)subtitleForTableViewCell;
- (BOOL)containsObject:(NSManagedObject *)object;

@end

NS_ASSUME_NONNULL_END
