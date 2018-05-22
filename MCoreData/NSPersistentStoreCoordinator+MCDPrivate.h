//
//  NSPersistentStoreCoordinator+MCDPrivate.h
//  MCoreData
//
//  Created by Malcolm Hall on 17/05/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//
#import "NSPersistentStoreCoordinator+MCD.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSPersistentStoreCoordinator (MCDPrivate)

@property (weak, nonatomic, readwrite, setter=mcd_setPersistentContainer:) MCDPersistentContainer *mcd_persistentContainer;

@end

NS_ASSUME_NONNULL_END
