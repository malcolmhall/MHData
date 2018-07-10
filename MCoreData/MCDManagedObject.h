//
//  MCDManagedObject.h
//  MCoreData
//
//  Created by Malcolm Hall on 06/07/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDManagedObjectContext.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDManagedObject : NSManagedObject

@property (nullable, nonatomic, readonly, assign) __kindof MCDManagedObjectContext *managedObjectContext;

@end

NS_ASSUME_NONNULL_END
