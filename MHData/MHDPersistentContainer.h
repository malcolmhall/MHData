//
//  MHDPersistentContainer.h
//  MHData
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
//  A back-port of NSPersistentContainer from the iOS 10 SDK

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MHData/MHDPersistentStoreDescription.h>

NS_ASSUME_NONNULL_BEGIN

@class MHDPersistentStoreDescription;

@interface MHDPersistentContainer : NSObject

+ (instancetype)persistentContainerWithName:(NSString *)name;
+ (instancetype)persistentContainerWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model;

+ (NSURL *)defaultDirectoryURL;

@property (copy, readonly) NSString *name;
@property (strong, readonly) NSManagedObjectContext *viewContext;
@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (copy) NSArray<MHDPersistentStoreDescription *> *persistentStoreDescriptions;

-(instancetype)init NS_UNAVAILABLE;

// Creates a container using the model named `name` in the main bundle, or the merged model (from the main bundle) if no match was found.
- (instancetype)initWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model NS_DESIGNATED_INITIALIZER;

// Load stores from the storeDescriptions property that have not already been successfully added to the container. The completion handler is called once for each store that succeeds or fails.
- (void)loadPersistentStoresWithCompletionHandler:(void (^)(MHDPersistentStoreDescription *, NSError * _Nullable))block;

- (NSManagedObjectContext *)newBackgroundContext NS_RETURNS_RETAINED;
- (void)performBackgroundTask:(void (^)(NSManagedObjectContext *))block;

@end

NS_ASSUME_NONNULL_END

