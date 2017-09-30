//
//  NSManagedObject+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (MCD)

// getter
- (id)objectForKeyedSubscript:(NSString *)key;

// setter
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

// finds the entity that has this class's name as its managedObjectClassName.
- (instancetype)mcd_initWithContext:(NSManagedObjectContext *)context;

+ (instancetype)mcd_objectFromObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectIDsFromObjects:(NSArray *)objects;
+ (NSArray *)mcd_objectIDsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectIDsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(nullable NSArray *)sortDescriptors context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectsFromObjectIDs:(NSArray *)objectIDs context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectsFromObjectIDs:(NSArray *)objectIDs relationshipKeyPathsForPrefetching:(nullable NSArray *)keyPaths context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectsMatchingPredicate:(nullable NSPredicate *)predicate context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectsMatchingPredicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray *)sortDescriptors context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_objectsMatchingPredicate:(nullable NSPredicate *)predicate sortDescriptors:(nullable NSArray *)sortDescriptors relationshipKeyPathsForPrefetching:(nullable NSArray *)keyPaths context:(NSManagedObjectContext *)context;
+ (NSArray *)mcd_permanentObjectIDsFromObjects:(NSArray *)objects;
+ (NSArray *)mcd_resultsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(nullable NSArray *)sortDescriptors resultType:(NSFetchRequestResultType)resultType relationshipKeyPathsForPrefetching:(nullable NSArray *)keyPaths context:(NSManagedObjectContext *)context;
- (BOOL)mcd_obtainPermanentObjectIDIfNecessary;
- (NSManagedObjectID *)mcd_permanentObjectID;
- (void)mcd_postNotificationOnMainThreadAfterSaveWithName:(NSString *)name;
- (void)mcd_postNotificationOnMainThreadWithName:(NSString *)name;
+ (NSUInteger)mcd_countOfObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
