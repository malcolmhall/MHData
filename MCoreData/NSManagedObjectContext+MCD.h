//
//  NSManagedObjectContext+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectContext (MCD)

// returns a main queue context using the default persistent store coordinator.
// exceptions if fails to create the store.
+(instancetype)mcd_defaultContext;

// Creates a new managed object context associated with a private queue.
// Designed to work on a context that already has an SQLite store added because it creates a new coordinator with the same URL.
-(NSManagedObjectContext *)mcd_newBackgroundContextWithError:(NSError **)error;

// creates a child context with the same concurrency type.
-(NSManagedObjectContext*)mcd_createChildContext;

// exceptions if entity does not exist
//-(NSManagedObject*)mcd_insertNewObjectForEntityName:(NSString*)name;

//-(NSEntityDescription*)mcd_entityDescriptionForName:(NSString*)name;

// check for nil array on error.
- (NSArray *)mcd_fetchObjectsWithEntityName:(NSString*)entityName predicate:(nullable NSPredicate*)predicate error:(NSError**)error;

// dictionary of keys and values that an and predicate will be used. Include NSNull for null values in the query.
- (NSArray *)mcd_fetchObjectsWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error;

// If there was an error fetching the error is set and nil is returned. If in an insert is required an object will always be returned with no error.
- (NSManagedObject*)mcd_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error;

// errors if not found
- (NSManagedObject *)mcd_existingObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary *)dictionary error:(NSError**)error;

// errors if not found
- (NSManagedObject *)mcd_existingObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate *)predicate error:(NSError**)error;

- (BOOL)mcd_saveRollbackOnError:(NSError**)error;

// function is one of the predefined NSExpression functions, e.g. max: sum: etc. Returns nil if there is no value.
- (id)mcd_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(nullable NSPredicate*)predicate error:(NSError**)error;

@property (nonatomic, setter=mcd_setAutomaticallyMergesChangesFromParent:) BOOL mcd_automaticallyMergesChangesFromParent;

// This wait so that the next operation in the queue doesn't start too soon.
- (NSOperation *)mcd_operationPerformingBlockAndWait:(void (^)())block;

// when saving a context into its parent, if it errors this method allows you to automatically undo the changes.
//- (BOOL)mcd_saveUndoParentOnError:(NSError**)error;

@end

NS_ASSUME_NONNULL_END
