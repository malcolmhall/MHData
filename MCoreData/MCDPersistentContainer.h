//
//  MCDPersistentContainer.h
//  MCoreData
//
//  Created by Malcolm Hall on 22/05/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDPersistentContainer : NSPersistentContainer

//@property (strong, nonatomic) NSMergePolicy *mergePolicy;

//- (void)backupPersistentStore;

- (NSURL *)storeURL;

// convenience for the first store descrption
@property (strong, nonatomic, readonly) NSPersistentStoreDescription *storeDescription;

- (void)backupPersistentStore;

@end

@interface NSPersistentStoreCoordinator (MCDPersistentContainer)

// provides access to the container that created this coordinator.
@property (weak, nonatomic, readonly) __kindof MCDPersistentContainer *mcd_persistentContainer;

@end

NS_ASSUME_NONNULL_END
