//
//  MCDManagedObjectChangeController.m
//  MCoreData
//
//  Created by Malcolm Hall on 11/08/2019.
//  Copyright © 2019 Malcolm Hall. All rights reserved.
//

#import "MCDManagedObjectChangeController.h"

@interface MCDManagedObjectChangeController()

@property (strong, nonatomic) NSManagedObject *managedObject;

@end

@implementation MCDManagedObjectChangeController

- (instancetype)initWithManagedObject:(NSManagedObject *)managedObject managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    NSAssert(managedObject, @"managedObject cannot be nil");
    NSAssert(managedObjectContext, @"managedObjectContext cannot be nil");
    self = [super init];
    if (self) {
        _managedObject = managedObject;
        //_isDeleted = [managedObjectContext.deletedObjects containsObject:managedObject];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:managedObjectContext];
    }
    return self;
}

- (void)managedObjectContextObjectsDidChangeNotification:(NSNotification *)notification{
    if([notification.userInfo[NSInsertedObjectsKey] containsObject:self.managedObject]){
        [self notifyDidChange:MCDManagedObjectChangeInsert];
    }
    if([notification.userInfo[NSUpdatedObjectsKey] containsObject:self.managedObject]){
        [self notifyDidChange:MCDManagedObjectChangeUpdate];
    }
    if([notification.userInfo[NSDeletedObjectsKey] containsObject:self.managedObject]){
        //self.isDeleted = YES;
        [self notifyDidChange:MCDManagedObjectChangeDelete];
    }
}

//- (void)setIsDeleted:(BOOL)isDeleted{
//    if(_isDeleted == isDeleted){
//        return;
//    }
//    _isDeleted = isDeleted;
//    [self notifyDidChange:MCDManagedObjectChangeDelete];
//}

- (void)notifyDidChange:(MCDManagedObjectChangeType)type{
    if([self.delegate respondsToSelector:@selector(controller:didChange:)]){
        [self.delegate controller:self didChange:type];
    }
}

@end
