//
//  NSManagedObjectContext+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define mh_defaultContext MHDATA_ADD_PREFIX(mh_defaultContext)
#define mh_createPrivateQueueContextWithError MHDATA_ADD_PREFIX(mh_defaultContext)
#define mh_createChildContext MHDATA_ADD_PREFIX(mh_createChildContext)
#define mh_insertNewObjectForEntityName MHDATA_ADD_PREFIX(mh_insertNewObjectForEntityName)
#define mh_entityDescriptionForName MHDATA_ADD_PREFIX(mh_entityDescriptionForName)
#define mh_fetchObjectsWithEntityName MHDATA_ADD_PREFIX(mh_fetchObjectsWithEntityName)
#define mh_fetchObjectWithEntityName MHDATA_ADD_PREFIX(mh_fetchObjectWithEntityName)
#define mh_fetchOrInsertObjectWithEntityName MHDATA_ADD_PREFIX(mh_fetchOrInsertObjectWithEntityName)
#define mh_save MHDATA_ADD_PREFIX(mh_save)
#define mh_fetchValueForAggregateFunction MHDATA_ADD_PREFIX(mh_fetchValueForAggregateFunction)

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext (MH)

// returns a main queue context using the default persistent store coordinator.
// exceptions if fails to create the store.
+(instancetype)mh_defaultContext;

// Creates a new managed object context associated with a private queue.
// Designed to work on a context that already has an SQLite store added because it creates a new coordinator with the same URL.
-(NSManagedObjectContext *)mh_createPrivateQueueContextWithError:(NSError **)error;

// creates a child context with the same concurrency type.
-(NSManagedObjectContext*)mh_createChildContext;

//exceptions if entity does not exist
-(NSManagedObject*)mh_insertNewObjectForEntityName:(NSString*)name;

-(NSEntityDescription*)mh_entityDescriptionForName:(NSString*)name;

- (NSArray*)mh_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

- (id)mh_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

// dictionary of keys and values that an and predicate will be used. Include NSNull for null values in the query.
- (NSManagedObject*)mh_fetchObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error;

// If there was an error fetching the error is set and nil is returned. If in an insert is required an object will always be returned with no error.
- (NSManagedObject*)mh_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error;

- (BOOL)mh_save:(NSError**)error rollbackOnError:(BOOL)rollbackOnError;

// function is one of the predefined NSExpression functions, e.g. max: sum: etc. Returns nil if there is no value.
- (id)mh_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END