//
//  MCDManagedObjectTableViewCell.h
//  MCoreData
//
//  Created by Malcolm Hall on 27/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

@import CoreData;

NS_ASSUME_NONNULL_BEGIN

@protocol MCDTableViewCellObject <NSObject>

- (NSString *)tableViewCellIdentifier;
// the keys of the object that are viewed in the cell. Update views will be called when their values change.
//+ (NSSet<NSString *> *)keyPathsForTableViewCell;
- (NSString *)titleForTableViewCell;
@optional
- (NSString *)subtitleForTableViewCell;
- (BOOL)containsObject:(NSManagedObject *)object;

@end

NS_ASSUME_NONNULL_END
