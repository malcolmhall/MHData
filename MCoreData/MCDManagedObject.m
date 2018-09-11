//
//  MCDManagedObject.m
//  MCoreData
//
//  Created by Malcolm Hall on 06/07/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDManagedObject.h"

@implementation MCDManagedObject

- (MCDManagedObjectContext *)managedObjectContext{
    NSManagedObjectContext *moc = super.managedObjectContext;
    return [moc isKindOfClass:MCDManagedObjectContext.class] ? (MCDManagedObjectContext *)moc : nil;
}

@end
