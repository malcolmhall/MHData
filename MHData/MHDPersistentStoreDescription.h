//
//  MHDPersistentStoreDescription.h
//  MHData
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//
//  A back-port of NSPersistentStoreDescription from the iOS 10 SDK

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000

// An instance of MHDPersistentStoreDescription encapsulates all information needed to describe a persistent store.
@interface MHDPersistentStoreDescription : NSObject //<NSCopying>

+ (instancetype)persistentStoreDescriptionWithURL:(NSURL *)URL;

@property (copy) NSString *type;
@property (copy, nullable) NSString *configuration;
@property (copy, nullable) NSURL *URL;
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSObject *> *options;

- (void)setOption:(nullable NSObject *)option forKey:(NSString *)key;

// Store options
@property (getter = isReadOnly) BOOL readOnly;
@property NSTimeInterval timeout;
@property (nonatomic, copy, readonly) NSDictionary<NSString *, NSObject *> *sqlitePragmas;

- (void)setValue:(nullable NSObject *)value forPragmaNamed:(NSString *)name;

// addPersistentStore-time behaviours
@property BOOL shouldAddStoreAsynchronously;
@property BOOL shouldMigrateStoreAutomatically;
@property BOOL shouldInferMappingModelAutomatically;

// Returns a store description instance with default values for the store located at `URL` that can be used immediately with `addPersistentStoreWithDescription:completionHandler:`.
- (instancetype)initWithURL:(NSURL *)URL NS_DESIGNATED_INITIALIZER;

@end

//@compatibility_alias NSPersistentStoreDescription MHDPersistentStoreDescription;

//#else
//#define __NSPersistentStoreDescription__(a) a
//#define MHDPersistentStoreDescription __NSPersistentStoreDescription__(NSPersistentStoreDescription)
//#endif

NS_ASSUME_NONNULL_END
