//
//  NSPersistentStoreCoordinator+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>
#import <MHData/MHDPersistentStoreDescription.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSPersistentStoreCoordinator (MHD)

// returns a shared instance of a coordinator using the mhd_defaultManagedObjectModel and mhd_defaultSQLiteStoreURL.

+ (NSPersistentStoreCoordinator*)mhd_defaultCoordinatorWithError:(NSError**)error;

// returns a new instance of a coordinator using the mhd_defaultManagedObjectModel and mhd_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mhd_coordinator;

// returns a new instance of a coordinator using the supplied model and mhd_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mhd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model;

// convenience for creating a coordinator with a sqlite store already added.

+ (NSPersistentStoreCoordinator*)mhd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error;

// Adds a sqlite store at the url with default options.
- (NSPersistentStore*)mhd_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error;

// Returns a URL path within Application Support/Executable Name/Bundle ID.sqlite creating directories as necessary.
+ (NSURL *)mhd_defaultStoreURLWithError:(NSError**)error;

// Returns the Bundle ID.sqlite
+ (NSString*)mhd_defaultStoreFilename;

// Returns the path to Application Support/Executable Name creating directories as necessary.
+ (NSURL *)mhd_applicationSupportDirectoryWithError:(NSError**)error;

- (void)mhd_addPersistentStoreWithDescription:(MHDPersistentStoreDescription *)storeDescription completionHandler:(void (^)(MHDPersistentStoreDescription *, NSError * _Nullable))block;

@end

NS_ASSUME_NONNULL_END