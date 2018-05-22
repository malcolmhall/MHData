//
//  NSPersistentStoreCoordinator+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class MCDNSPersistentStoreDescription, MCDPersistentContainer;

@interface NSPersistentStoreCoordinator (MCD)

// returns a shared instance of a coordinator using the mcd_defaultManagedObjectModel and mcd_defaultSQLiteStoreURL.

+ (NSPersistentStoreCoordinator *)mcd_defaultCoordinatorWithError:(NSError **)error;

// returns a new instance of a coordinator using the mcd_defaultManagedObjectModel and mcd_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mcd_coordinator;

// returns a new instance of a coordinator using the supplied model and mcd_defaultSQLiteStoreURL.
//+ (NSPersistentStoreCoordinator*)mcd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model;

// convenience for creating a coordinator with a sqlite store already added.

+ (NSPersistentStoreCoordinator *)mcd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL *)storeURL error:(NSError **)error;

// Adds a sqlite store at the url with default options.
- (NSPersistentStore *)mcd_addStoreWithURL:(NSURL *)storeURL error:(NSError **)error;

// Returns a URL path within Application Support/Executable Name/Bundle ID.sqlite creating directories as necessary.
+ (NSURL *)mcd_defaultStoreURLWithError:(NSError **)error;

// Returns the Bundle ID.sqlite
@property (class, readonly, strong) NSString *mcd_defaultStoreFilename;

// Returns the path to Application Support/Executable Name creating directories as necessary.
+ (NSURL *)mcd_applicationSupportDirectoryWithError:(NSError **)error;

- (void)mcd_addPersistentStoreWithDescription:(MCDNSPersistentStoreDescription *)storeDescription completionHandler:(void (^)(MCDNSPersistentStoreDescription *, NSError * _Nullable))block;

// provides access to the container that created this coordinator.
@property (weak, nonatomic, readonly) MCDPersistentContainer *mcd_persistentContainer;

@end

NS_ASSUME_NONNULL_END
