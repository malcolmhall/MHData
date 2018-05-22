//
//  MCDPersistentContainer.m
//  MCoreData
//
//  Created by Malcolm Hall on 22/05/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDPersistentContainer.h"
#import "NSPersistentStoreCoordinator+MCDPrivate.h"

@implementation MCDPersistentContainer

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super initWithName:name managedObjectModel:model];
    if (self) {
        self.persistentStoreCoordinator.mcd_persistentContainer = self;
    }
    return self;
}

@end
