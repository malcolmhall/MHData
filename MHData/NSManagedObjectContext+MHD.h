//
//  NSManagedObjectContext+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext (MHD)

// returns a main queue context using the default persistent store coordinator.
// exceptions if fails to create the store.
+(instancetype)mhd_defaultContext;

// Creates a new managed object context associated with a private queue.
// Designed to work on a context that already has an SQLite store added because it creates a new coordinator with the same URL.
-(NSManagedObjectContext *)mhd_newBackgroundContextWithError:(NSError **)error;

// creates a child context with the same concurrency type.
-(NSManagedObjectContext*)mhd_createChildContext;

// exceptions if entity does not exist
//-(NSManagedObject*)mhd_insertNewObjectForEntityName:(NSString*)name;

//-(NSEntityDescription*)mhd_entityDescriptionForName:(NSString*)name;

// check for nil array on error.
- (NSArray *)mhd_fetchObjectsWithEntityName:(NSString*)entityName predicate:(nullable NSPredicate*)predicate error:(NSError**)error;

// dictionary of keys and values that an and predicate will be used. Include NSNull for null values in the query.
- (NSArray *)mhd_fetchObjectsWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error;

// If there was an error fetching the error is set and nil is returned. If in an insert is required an object will always be returned with no error.
- (NSManagedObject*)mhd_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error;

// errors if not found
- (NSManagedObject *)mhd_existingObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary *)dictionary error:(NSError**)error;

// errors if not found
- (NSManagedObject *)mhd_existingObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate *)predicate error:(NSError**)error;

- (BOOL)mhd_saveRollbackOnError:(NSError**)error;

// function is one of the predefined NSExpression functions, e.g. max: sum: etc. Returns nil if there is no value.
- (id)mhd_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(nullable NSPredicate*)predicate error:(NSError**)error;

@property (nonatomic, setter=mhd_setAutomaticallyMergesChangesFromParent:) BOOL mhd_automaticallyMergesChangesFromParent;

// This wait so that the next operation in the queue doesn't start too soon.
- (NSOperation *)mhd_operationPerformingBlockAndWait:(void (^)())block;

// when saving a context into its parent, if it errors this method allows you to automatically undo the changes.
//- (BOOL)mhd_saveUndoParentOnError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END