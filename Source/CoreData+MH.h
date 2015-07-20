//
//  CoreData+MH.h
//  MHData
//
//  Created by Malcolm Hall on 20/06/2009.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

// It should be possible to use different instances with the same filename on different threads. The instances will share the same persistant coordinator.

#import <CoreData/CoreData.h>

@interface NSManagedObjectModel (MH)

// Easily load a model from a model file and caches it. Do not include any file extension.
+(NSManagedObjectModel*)mh_modelNamed:(NSString*)name;

@end

@interface NSManagedObjectContext(MH)
    
// returns a managed object context using the default persistent store coordinator.
+(instancetype)mh_defaultManagedObjectContext;

// returns a managed object context with the given store coordinator.
+(instancetype)mh_managedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)persistentStoreCoordinator;

 //exceptions if entity does not exist
 -(NSManagedObject*)mh_insertNewObjectForEntityName:(NSString*)name;

 -(NSEntityDescription*)mh_entityDescriptionForName:(NSString*)name;

 - (NSArray*)mh_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;
 - (id)mh_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;
 // dictionary of keys and values that an and predicate will be used. Include NSNull for null values in the query.
 -(NSManagedObject*)mh_fetchObjectWithDictionary:(NSDictionary*)dictionary entityName:(NSString*)entityName error:(NSError**)error;

@end


@interface NSPersistentStoreCoordinator (MH)

// returns a shared persistent coorindator using the mh_defaultManagedObjectModel and mh_defaultSQLiteStoreURL.
+(NSPersistentStoreCoordinator*)mh_defaultPersistentStoreCoordinator;

// returns a shared coordinator that uses the same SQLiteStoreURL as previous calls to this method. The first time this is called the specified model is used to create the store. If you specify the default store path you will receive the same as calling defaultPersistentStoreCoordinator. 
+(NSPersistentStoreCoordinator*)mh_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL;

// returns a new persistent store coordinater with the specified managed object model at the default store URL.
+(NSPersistentStoreCoordinator*)mh_persistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL managedObjectModel:(NSManagedObjectModel*)managedObjectModel ;

+(NSURL*)mh_defaultSQLiteStoreURL;

// -(BOOL)mh_deleteStore;

@end


@interface NSManagedObject (KeyedSubscript)

// getter
- (id)objectForKeyedSubscript:(NSString*)key;

// setter
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

@end

