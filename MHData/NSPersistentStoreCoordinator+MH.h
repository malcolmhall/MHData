//
//  NSPersistentStoreCoordinator+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define mh_defaultCoordinatorWithError MHDATA_ADD_PREFIX(mh_defaultCoordinatorWithError)
#define mh_coordinatorWithManagedObjectModel MHDATA_ADD_PREFIX(mh_coordinatorWithManagedObjectModel)
#define mh_addStoreWithURL MHDATA_ADD_PREFIX(mh_addStoreWithURL)
#define mh_defaultStoreURLWithError MHDATA_ADD_PREFIX(mh_defaultStoreURLWithError)
#define mh_defaultStoreFilename MHDATA_ADD_PREFIX(mh_defaultStoreFilename)
#define mh_applicationSupportDirectoryWithError MHDATA_ADD_PREFIX(mh_applicationSupportDirectoryWithError)

NS_ASSUME_NONNULL_BEGIN

@interface NSPersistentStoreCoordinator (MH)

// returns a shared instance of a coordinator using the mh_defaultManagedObjectModel and mh_defaultSQLiteStoreURL.

+ (NSPersistentStoreCoordinator*)mh_defaultCoordinatorWithError:(NSError**)error;

// returns a new instance of a coordinator using the mh_defaultManagedObjectModel and mh_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mh_coordinator;

// returns a new instance of a coordinator using the supplied model and mh_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mh_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model;

// convenience for creating a coordinator with a sqlite store already added.

+ (NSPersistentStoreCoordinator*)mh_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error;

// Adds a sqlite store at the url with default options.
- (NSPersistentStore*)mh_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error;

// Returns a URL path within Application Support/Executable Name/Bundle ID.sqlite creating directories as necessary.
+ (NSURL *)mh_defaultStoreURLWithError:(NSError**)error;

// Returns the Bundle ID.sqlite
+ (NSString*)mh_defaultStoreFilename;

// Returns the path to Application Support/Executable Name creating directories as necessary.
+ (NSURL *)mh_applicationSupportDirectoryWithError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END