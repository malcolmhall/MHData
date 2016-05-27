//
//  MHCoreDataStackManager.m
//  MHData
//
//  Created by Malcolm Hall on 08/02/2016.
//
//

#import "MHCoreDataStackManager.h"
#import "NSManagedObjectModel+MH.h"
#import "NSPersistentStoreCoordinator+MH.h"

@interface MHDATA_ADD_PREFIX(MHCoreDataStackManager)()

@property (nonatomic, readwrite) NSManagedObjectContext* mainContext;

@end

@implementation MHDATA_ADD_PREFIX(MHCoreDataStackManager)

+ (instancetype)sharedManager {
    static MHDATA_ADD_PREFIX(MHCoreDataStackManager) *sharedManager = nil;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedManager = [[self alloc] init];
    });
    
    return sharedManager;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        _managedObjectModel = [NSManagedObjectModel MH_defaultModel];
    }
    return _managedObjectModel;
}

- (NSURL *)storeURL {
    if (!_storeURL) {
        NSError* error;
        _storeURL = [NSPersistentStoreCoordinator MH_defaultStoreURLWithError:&error];
        if(!_storeURL){
            [NSException raise:NSInternalInconsistencyException format:@"Failed to create store path %@", error];
        }
    }
    return _storeURL;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        NSError* error;
        _persistentStoreCoordinator = [NSPersistentStoreCoordinator MH_coordinatorWithManagedObjectModel:self.managedObjectModel storeURL:self.storeURL error:&error];
        if(!_persistentStoreCoordinator){
            [NSException raise:NSInternalInconsistencyException format:@"Failed to create store %@", error];
        }
    }
    return _persistentStoreCoordinator;
}

-(NSManagedObjectContext*)mainContext{
    if(!_mainContext){
        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return _mainContext;
}

@end
