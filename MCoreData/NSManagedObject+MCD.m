//
//  NSManagedObject+MCD.m
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSManagedObject+MCD.h"
#import <MHFoundation/MHFoundation.h>

@implementation NSManagedObject (MCD)

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self valueForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    NSParameterAssert([(id<NSObject>)key isKindOfClass:[NSString class]]);
    [self setValue:object forKey:(NSString *)key];
}

- (instancetype)mcd_initWithContext:(NSManagedObjectContext *)context{
    // search for this class in the model to find the entity
    NSEntityDescription* entity;
    NSString * className = NSStringFromClass(self.class);
    NSPersistentStoreCoordinator *psc = context.persistentStoreCoordinator;
    for(NSEntityDescription* e in psc.managedObjectModel.entities){
        if([e.managedObjectClassName isEqualToString:className]){
            entity = e;
            break;
        }
        // we won't check if there are any more matches
    }
    if(!entity){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Could not find an entity for this class" userInfo:nil];
    }
    return [self initWithEntity:entity insertIntoManagedObjectContext:context];
}


+ (NSManagedObject *)mcd_objectFromObjectID:(NSManagedObjectID *)objectID context:(NSManagedObjectContext *)context{
    if(!objectID){
        NSLog(@"Trying to get an object from a nil object ID: %@", [NSThread callStackSymbols]);
        return nil;
    }
    NSError *error;
    NSManagedObject *object = [context existingObjectWithID:objectID error:&error];
    object = MHFCheckedDynamicCast([self class], object);
    if(error){
        if(error.code == NSManagedObjectReferentialIntegrityError){
            NSLog(@"Unable to find object from objectID: %@", objectID);
        }
        else{
            NSLog(@"Error finding object from objectID: %@, %@", objectID, error);
        }
    }
    return object;
}

+ (NSArray *)mcd_objectIDsFromObjects:(NSArray *)objects{
    NSMutableArray *objectIDs = [NSMutableArray array];
    for(NSManagedObject *object in objects){
        NSManagedObjectID *objectID = object.objectID;
        if(objectID){
            [objectIDs addObject:objectID];
        }
    }
    return objectIDs;
}

+ (NSArray *)mcd_objectIDsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context{
    @throw [NSException mhf_notImplementedException];
}

+ (NSArray *)mcd_objectIDsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors context:(NSManagedObjectContext *)context{
    @throw [NSException mhf_notImplementedException];
}

+ (NSArray *)mcd_objectsFromObjectIDs:(NSArray *)objectIDs context:(NSManagedObjectContext *)context{
    NSMutableArray *objects = [NSMutableArray array];
    for(NSManagedObjectID *objectID in objectIDs){
        NSManagedObject* object = [self mcd_objectFromObjectID:objectID context:context];
        if(object){
            [objects addObject:object];
        }
    }
    return objects;
}

+ (NSArray *)mcd_objectsFromObjectIDs:(NSArray *)objectIDs relationshipKeyPathsForPrefetching:(NSArray *)relationshipKeyPaths context:(NSManagedObjectContext *)context{
    @throw [NSException mhf_notImplementedException];
}

+ (NSArray *)mcd_objectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context{
    return [self mcd_objectsMatchingPredicate:predicate sortDescriptors:nil context:context];
}

+ (NSArray *)mcd_objectsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors context:(NSManagedObjectContext *)context{
    __block NSFetchRequest *fetchRequest = self.fetchRequest;
    if(!fetchRequest){
        [context performBlockAndWait:^{
            fetchRequest = self.fetchRequest;
        }];
    }
    fetchRequest.predicate = predicate;
    fetchRequest.sortDescriptors = sortDescriptors;
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching %@ (predicate=%@ sortDescriptors=%@): %@", self.class, predicate, sortDescriptors, error);
    }
    else if(!results){
        NSLog(@"Nil objects array fetching %@ (predicate=%@ sortDescriptors=%@ context=%@)", self.class, predicate, sortDescriptors, context);
    }
    return results;
}

+ (NSArray *)mcd_objectsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors relationshipKeyPathsForPrefetching:(NSArray *)relationshipKeyPathsForPrefetching context:(NSManagedObjectContext *)context{
    return [self mcd_resultsMatchingPredicate:predicate sortDescriptors:sortDescriptors resultType:0 relationshipKeyPathsForPrefetching:relationshipKeyPathsForPrefetching context:context];
}

+ (NSArray *)mcd_permanentObjectIDsFromObjects:(NSArray *)objects{
    NSManagedObject *object = objects.firstObject;
    if(object){
        NSArray *a = [objects mhf_objectsPassingTest:^BOOL(NSManagedObject *obj, NSUInteger idx, BOOL *stop) {
            return obj.objectID.isTemporaryID;
        }];
        NSError *error;
        if(![object.managedObjectContext obtainPermanentIDsForObjects:a error:&error]){
            NSLog(@"Error obtaining permanent object ID for objects with error: %@", error);
        }
    }
    return [self mcd_objectIDsFromObjects:objects];
}

+ (NSArray *)mcd_resultsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors resultType:(NSFetchRequestResultType)resultType relationshipKeyPathsForPrefetching:(NSArray *)relationshipKeyPathsForPrefetching context:(NSManagedObjectContext *)context{
    __block NSFetchRequest *fetchRequest = [self fetchRequest];
    if(!fetchRequest){
        [context performBlockAndWait:^{
            fetchRequest = self.fetchRequest;
        }];
    }
    fetchRequest.predicate = predicate;
    fetchRequest.resultType = resultType;
    fetchRequest.sortDescriptors = sortDescriptors;
    fetchRequest.relationshipKeyPathsForPrefetching = relationshipKeyPathsForPrefetching;
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    if(error){
        NSLog(@"Error fetching %@ (predicate=%@ sortDescriptors=%@): %@", self.class, predicate, sortDescriptors, error);
    }
    else if(!results){
        NSLog(@"Nil objects array fetching %@ (predicate=%@ sortDescriptors=%@ context=%@)", self.class, predicate, sortDescriptors, context);
    }
    return results;
}

- (BOOL)mcd_obtainPermanentObjectIDIfNecessary{
    if(!self.objectID.isTemporaryID){
        return YES;
    }
    NSError *error;
    if(![self.managedObjectContext obtainPermanentIDsForObjects:@[self] error:&error]){
        NSLog(@"Error obtaining permanent object ID for %@: %@", [self class], error);
        return NO;
    }
    return YES;
}

- (NSManagedObjectID *)mcd_permanentObjectID{
    [self mcd_obtainPermanentObjectIDIfNecessary];
    return self.objectID;
}

- (void)mcd_postNotificationOnMainThreadAfterSaveWithName:(NSString *)name{
    @throw [NSException mhf_notImplementedException];
}

- (void)mcd_postNotificationOnMainThreadWithName:(NSString *)name{
    @throw [NSException mhf_notImplementedException];
}

@end
