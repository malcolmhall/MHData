//
//  MCDManagedObjectContext.m
//  MCoreData
//
//  Created by Malcolm Hall on 06/07/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDManagedObjectContext.h"

@implementation MCDManagedObjectContext

- (instancetype)initWithConcurrencyType:(NSManagedObjectContextConcurrencyType)ct persistentContainer:(MCDPersistentContainer *)persistentContainer{
    self = [super initWithConcurrencyType:ct];
    if (self) {
        _persistentContainer = persistentContainer;
    }
    return self;
}

@end
