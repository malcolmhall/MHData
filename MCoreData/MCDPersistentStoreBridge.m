//
//  MCDPersistentStoreBridge.m
//  MCoreData
//
//  Created by Malcolm Hall on 16/07/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "MCDPersistentStoreBridge.h"

NSString * const MCDPersistentStoreBridgeWillExecuteRequestNotification = @"MCDPersistentStoreBridgeWillExecuteRequestNotification";
NSString * const MCDRequestKey = @"MCDRequestKey";
NSString * const MCDContextKey = @"MCDContextKey";

@implementation MCDPersistentStoreBridge{
    NSPersistentStoreCoordinator* _destinationPersistentStoreCoordinator;
    NSIncrementalStore* _destinationPersistentStore;
}

+ (void)initialize{
    if(self == MCDPersistentStoreBridge.class){
        [NSPersistentStoreCoordinator registerStoreClass:self forStoreType:self.type];
    }
}

+ (NSString *)type{
    return NSStringFromClass(self);
}

- (BOOL)loadMetadata:(NSError **)error{
    self.metadata = @{NSStoreUUIDKey : [NSProcessInfo processInfo].globallyUniqueString,
                      NSStoreTypeKey : self.class.type};
    
    _destinationPersistentStoreCoordinator = [NSPersistentStoreCoordinator.alloc initWithManagedObjectModel:self.persistentStoreCoordinator.managedObjectModel];
    
    NSString *storeType = self.options[NSStoreTypeKey];
    //TODO: error if NSStoreKey not in options dictionary.
    
    _destinationPersistentStore = (NSIncrementalStore*)[_destinationPersistentStoreCoordinator addPersistentStoreWithType:storeType configuration:self.configurationName URL:self.URL options:self.options error:error];
    
    return _destinationPersistentStore != nil;
}

- (id)executeRequest:(NSPersistentStoreRequest *)persistentStoreRequest withContext:(NSManagedObjectContext *)context error:(NSError **)error{
    NSDictionary *userInfo = @{MCDRequestKey : persistentStoreRequest,
                               MCDContextKey : context};
    [[NSNotificationCenter defaultCenter] postNotificationName:MCDPersistentStoreBridgeWillExecuteRequestNotification object:self userInfo:userInfo];

    return [_destinationPersistentStore executeRequest:persistentStoreRequest withContext:context error:error];
}

- (NSIncrementalStoreNode *)newValuesForObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error{
    return [_destinationPersistentStore newValuesForObjectWithID:objectID withContext:context error:error];
}

- (id)newValueForRelationship:(NSRelationshipDescription*)relationship forObjectWithID:(NSManagedObjectID *)objectID withContext:(NSManagedObjectContext *)context error:(NSError **)error{
    return [_destinationPersistentStore newValueForRelationship:relationship forObjectWithID:objectID withContext:context error:error];
}

- (NSArray*)obtainPermanentIDsForObjects:(NSArray*)array error:(NSError **)error{
    [_destinationPersistentStore obtainPermanentIDsForObjects:array error:error];
    return [array valueForKey:@"objectID"];
}

- (void)managedObjectContextDidRegisterObjectsWithIDs:(NSArray*)objectIDs{
    [_destinationPersistentStore managedObjectContextDidRegisterObjectsWithIDs:objectIDs];
}

- (void)managedObjectContextDidUnregisterObjectsWithIDs:(NSArray*)objectIDs{
    [_destinationPersistentStore managedObjectContextDidUnregisterObjectsWithIDs:objectIDs];
}

@end
