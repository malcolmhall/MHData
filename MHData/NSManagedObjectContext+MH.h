//
//  NSManagedObjectContext+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define MH_defaultContext MHDATA_ADD_PREFIX(MH_defaultContext)
#define MH_createPrivateQueueContextWithError MHDATA_ADD_PREFIX(MH_defaultContext)
#define MH_createChildContext MHDATA_ADD_PREFIX(MH_createChildContext)
#define MH_insertNewObjectForEntityName MHDATA_ADD_PREFIX(MH_insertNewObjectForEntityName)
#define MH_entityDescriptionForName MHDATA_ADD_PREFIX(MH_entityDescriptionForName)
#define MH_fetchObjectsWithEntityName MHDATA_ADD_PREFIX(MH_fetchObjectsWithEntityName)
#define MH_fetchObjectWithEntityName MHDATA_ADD_PREFIX(MH_fetchObjectWithEntityName)
#define MH_fetchOrInsertObjectWithEntityName MHDATA_ADD_PREFIX(MH_fetchOrInsertObjectWithEntityName)
#define MH_save MHDATA_ADD_PREFIX(MH_save)
#define MH_fetchValueForAggregateFunction MHDATA_ADD_PREFIX(MH_fetchValueForAggregateFunction)

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext (MH)

// returns a main queue context using the default persistent store coordinator.
// exceptions if fails to create the store.
+(instancetype)MH_defaultContext;

// Creates a new managed object context associated with a private queue.
// Designed to work on a context that already has an SQLite store added because it creates a new coordinator with the same URL.
-(NSManagedObjectContext *)MH_createPrivateQueueContextWithError:(NSError **)error;

// creates a child context with the same concurrency type.
-(NSManagedObjectContext*)MH_createChildContext;

//exceptions if entity does not exist
-(NSManagedObject*)MH_insertNewObjectForEntityName:(NSString*)name;

-(NSEntityDescription*)MH_entityDescriptionForName:(NSString*)name;

- (NSArray*)MH_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

- (id)MH_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

// dictionary of keys and values that an and predicate will be used. Include NSNull for null values in the query.
- (NSManagedObject*)MH_fetchObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error;

// If there was an error fetching the error is set and nil is returned. If in an insert is required an object will always be returned with no error.
- (NSManagedObject*)MH_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error;

- (BOOL)MH_save:(NSError**)error rollbackOnError:(BOOL)rollbackOnError;

// function is one of the predefined NSExpression functions, e.g. max: sum: etc. Returns nil if there is no value.
- (id)MH_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error;

@end

NS_ASSUME_NONNULL_END