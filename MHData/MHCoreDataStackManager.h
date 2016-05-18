//
//  MHCoreDataStackManager.h
//  AppTrack
//
//  Created by Malcolm Hall on 08/02/2016.
//
//
// The manager can be customized by subclassing and overriding the methods.
// Everything is lazy loaded and exceptions are raised on failures.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MHCoreDataStackManager : NSObject

// Singleton access
+ (instancetype)sharedManager;

/// Managed object model for the application, defaults to mh_defaultModel
@property (nonatomic) NSManagedObjectModel *managedObjectModel;

/// Primary persistent store coordinator for the application, defaults to mh_coordinatorWithManagedObjectModel
@property (nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/// URL for the Core Data store file, defaults to mh_defaultStoreURLWithError
@property (nonatomic) NSURL *storeURL;

// Main context for the application
@property (nonatomic, readonly) NSManagedObjectContext* mainContext;

@end
