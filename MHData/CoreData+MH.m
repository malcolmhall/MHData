//
//  CoreData+MH.m
//  MHData
//
//  Created by Malcolm Hall on 20/06/2009.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "CoreData+MH.h"

@implementation NSManagedObjectContext(MH)

+(instancetype)mh_managedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator*)persistentStoreCoordinator{
    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:persistentStoreCoordinator];
    return moc;
}

// designated init
+ (instancetype)mh_defaultManagedObjectContext{
    static NSManagedObjectContext* _defaultManagedObjectContext;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultManagedObjectContext = [NSManagedObjectContext mh_managedObjectContextWithPersistentStoreCoordinator:[NSPersistentStoreCoordinator mh_defaultPersistentStoreCoordinator]];
       
    });
    return _defaultManagedObjectContext;
}


-(NSManagedObject*)mh_insertNewObjectForEntityName:(NSString*)entityName{
    return  [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

-(NSEntityDescription*)mh_entityDescriptionForName:(NSString*)name{
    return [NSEntityDescription entityForName:name inManagedObjectContext:self];
}

 - (NSArray*)mh_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
 NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
 fetchRequest.predicate = predicateOrNil;
 return [self executeFetchRequest:fetchRequest error:error];
 }
 
 - (id)mh_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
     NSArray* objects = [self mh_fetchObjectsWithEntityName:entityName predicate:predicateOrNil error:error];
     return objects.firstObject;
 }
 
 -(NSManagedObject*)mh_fetchObjectWithDictionary:(NSDictionary*)dictionary entityName:(NSString*)entityName error:(NSError**)error{
     // build the and predicate using the dict that also checks nulls.
     NSMutableArray* array = [NSMutableArray array];
     [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         [array addObject:[NSPredicate predicateWithFormat:@"%K = %@", key, obj]];
     }];
     NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
     return [self mh_fetchObjectWithEntityName:entityName predicate:predicate error:error];
}

- (BOOL)mh_save:(NSError**)error rollbackOnError:(BOOL)rollbackOnError{
    BOOL result = [self save:error];
    if(!result){
        [self rollback];
    }
    return result;
}

@end

@implementation NSPersistentStoreCoordinator(MH)

+(NSPersistentStoreCoordinator*)mh_defaultPersistentStoreCoordinator{
    return [NSPersistentStoreCoordinator mh_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:[NSPersistentStoreCoordinator mh_defaultSQLiteStoreURL]];
}

+(NSPersistentStoreCoordinator*)mh_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL{
    
    static NSMutableDictionary* _persistentStoreCoordinators;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _persistentStoreCoordinators = [[NSMutableDictionary alloc] init];
    });
    
    NSPersistentStoreCoordinator* psc = [_persistentStoreCoordinators objectForKey:SQLiteStoreURL];
    if(!psc){
        psc = [self mh_persistentStoreCoordinatorWithSQLiteStoreURL:SQLiteStoreURL managedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
        [_persistentStoreCoordinators setObject:psc forKey:SQLiteStoreURL];
    }
    
    return psc;
}


+(NSPersistentStoreCoordinator*)mh_persistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)storeURL managedObjectModel:(NSManagedObjectModel*)managedObjectModel{
    NSPersistentStoreCoordinator* persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];
    
    NSError *error;
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                    [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                                    nil];
#ifdef DEBUG
    // turn off WAL because it means can't see things in the sqlite file its all in a binary log file.
    NSDictionary *pragmaOptions = [NSDictionary dictionaryWithObject:@"DELETE" forKey:@"journal_mode"];
    [options setObject: pragmaOptions forKey: NSSQLitePragmasOption];
#endif
    NSLog(@"%@", storeURL);
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        NSLog(@"Problem with PersistentStoreCoordinator: %@",error);
#ifdef DEBUG
        //todo: show modal uialert to delete it
        NSLog(@"Deleting old store because we are in debug anyway.");
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
#endif
        // try again
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            NSLog(@"Problem with PersistentStoreCoordinator: %@",error);
        //fatal error
            abort();
        }
    }
    return persistentStoreCoordinator;
}

+(NSURL*)mh_defaultSQLiteStoreURL{
    NSURL* dir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [dir URLByAppendingPathComponent:[[NSBundle mainBundle].bundleIdentifier stringByAppendingString:@".sqlite"]];
    
}

@end

@implementation NSManagedObjectModel(MH)

//helper for load model files
+(NSManagedObjectModel*)mh_modelNamed:(NSString *)name{
    static NSMutableDictionary *models = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        models = [[NSMutableDictionary alloc] init];
    });
    NSManagedObjectModel* model = [models objectForKey:name];
    if(!model){
        NSString* s = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"]; // mom is what it gets compiled to on the phone.
        if(!s){
            s = [[NSBundle mainBundle] pathForResource:name ofType:@"mom"]; // mom is what it gets compiled to on the phone.
            if(!s){
                [NSException raise:@"Invalid model name" format:@"model named %@ is invalid", name];
            }
        }
        //todo crash if s is null or not found.
        NSURL* url = [NSURL fileURLWithPath:s];
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        models[name] = model;
    }
    return model;
}

@end

@implementation NSManagedObject (KeyedSubscript)

- (id)objectForKeyedSubscript:(NSString*)key {
    return [self valueForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    NSParameterAssert([(id<NSObject>)key isKindOfClass:[NSString class]]);
    [self setValue:object forKey:(NSString*)key];
}

@end
