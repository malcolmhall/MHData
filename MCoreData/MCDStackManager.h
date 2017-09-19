//
//  MCDStackManager.h
//  MCoreData
//
//  Created by Malcolm Hall on 08/02/2016.
//
//
// The manager is a helper for customizing part of a default stack.
// Everything is lazy loaded and exceptions are raised on failures.
// Inspired by AAPLCoreDataStackManager.h from Earthquake.

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDStackManager : NSObject

// Singleton access
+ (instancetype)sharedManager;

/// Managed object model for the application, defaults to mcd_defaultModel
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

/// Primary persistent store coordinator for the application, defaults to mcd_coordinatorWithManagedObjectModel
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/// URL for the Core Data store file, defaults to mcd_defaultStoreURLWithError
@property (nonatomic, strong) NSURL *storeURL;

// Main context for the application, calls each of the above properties in turn.
@property (nonatomic, strong, readonly) NSManagedObjectContext *mainContext;

@end

NS_ASSUME_NONNULL_END
