//
//  NSManagedObjectContext+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <MHData/NSManagedObjectContext+MHD.h>
#import <MHData/MHDataDefines.h>
#import <MHData/NSPersistentStoreCoordinator+MHD.h>

@implementation NSManagedObjectContext (MHD)

+ (instancetype)mhd_defaultContextWithError:(NSError**)error{
    static NSManagedObjectContext* _defaultManagedObjectContext;
    if(!_defaultManagedObjectContext){
        NSPersistentStoreCoordinator* psc = [NSPersistentStoreCoordinator mhd_defaultCoordinatorWithError:error];
        if(!psc){
            return nil;
        }
        _defaultManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _defaultManagedObjectContext.persistentStoreCoordinator = psc;
    };
    return _defaultManagedObjectContext;
}

+ (instancetype)mhd_defaultContext{
    NSError* error;
    NSManagedObjectContext* context = [self mhd_defaultContextWithError:&error];
    if(error){
        [NSException raise:NSInternalInconsistencyException format:@"Failed to create default context %@", error];
    }
    return context;
}


-(NSManagedObjectContext*)mhd_createChildContext{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:self.concurrencyType];
    context.parentContext = self;
    return context;
}

- (NSManagedObjectContext *)mhd_createPrivateQueueContextWithError:(NSError **)error {
    
    // It uses the same store and model, but a new persistent store coordinator and context.
    NSPersistentStoreCoordinator *localCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.persistentStoreCoordinator.managedObjectModel];
    
    NSPersistentStore* store = self.persistentStoreCoordinator.persistentStores.firstObject;
    
    NSURL* storeURL = store.URL;
    if(!storeURL){
        if(error){
            *error = [NSError errorWithDomain:MHDataErrorDomain code:101 userInfo:@{NSLocalizedDescriptionKey : @"Could not find the coordinator's first store URL",
                                                                              NSLocalizedFailureReasonErrorKey : @"It was nil."}];
        }
        return nil;
    }
    
    if (![localCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:store.configurationName
                                                  URL:storeURL
                                              options:store.options
                                                error:error]) {
        return nil;
    }
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    [context performBlockAndWait:^{
        [context setPersistentStoreCoordinator:localCoordinator];
        
        // Avoid using default merge policy in multi-threading environment:
        // when we delete (and save) a record in one context,
        // and try to save edits on the same record in the other context before merging the changes,
        // an exception will be thrown because Core Data by default uses NSErrorMergePolicy.
        // Setting a reasonable mergePolicy is a good practice to avoid that kind of exception.
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
        
        // In OS X, a context provides an undo manager by default
        // Disable it for performance benefit
        context.undoManager = nil;
    }];
    return context;
}

-(NSManagedObject*)mhd_insertNewObjectForEntityName:(NSString*)entityName{
    return  [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

-(NSEntityDescription*)mhd_entityDescriptionForName:(NSString*)name{
    return [NSEntityDescription entityForName:name inManagedObjectContext:self];
}

-(NSArray*)mhd_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicateOrNil;
    return [self executeFetchRequest:fetchRequest error:error];
}

- (id)mhd_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
    NSArray* objects = [self mhd_fetchObjectsWithEntityName:entityName predicate:predicateOrNil error:error];
    return objects.firstObject;
}

-(NSManagedObject*)mhd_fetchObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error{
    // build the and predicate using the dict that also checks nulls.
    NSMutableArray* array = [NSMutableArray array];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [array addObject:[NSPredicate predicateWithFormat:@"%K = %@", key, obj]];
    }];
    NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
    return [self mhd_fetchObjectWithEntityName:entityName predicate:predicate error:error];
}

-(NSManagedObject*)mhd_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error{
    NSError* e;
    
    // initialize inserted
    if(inserted){
        *inserted = NO;
    }
    
    NSManagedObject* object = [self mhd_fetchObjectWithEntityName:entityName dictionary:dictionary error:&e];
    if(e){
        // nil pointer check
        if(error){
            *error = e;
        }
        return nil;
    }
    else if(!object){
        object = [self mhd_insertNewObjectForEntityName:entityName];
        [object setValuesForKeysWithDictionary:dictionary];
        // nil pointer check
        if(inserted){
            *inserted = YES;
        }
    }
    return object;
}

-(id)mhd_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
    // todo validate these
    NSEntityDescription* entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSAttributeDescription* attribute = entity.attributesByName[attributeName];
    
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:attribute.name];
    
    NSExpression *maxExpression = [NSExpression
                                   expressionForFunction:function
                                   arguments:@[keyPathExpression]];
    
    NSString* resultKey = @"resultKey";
    
    NSExpressionDescription *description = [[NSExpressionDescription alloc] init];
    description.name = resultKey;
    description.expression = maxExpression;
    description.expressionResultType = attribute.attributeType;
    
    // find highest recordChangeTag
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    fetchRequest.propertiesToFetch = @[description];
    fetchRequest.resultType = NSDictionaryResultType;
    fetchRequest.predicate = predicateOrNil;
    
    NSArray* fetchResults = [self executeFetchRequest:fetchRequest error:error];
    
    return [[fetchResults lastObject] valueForKey:resultKey];
}

- (BOOL)mhd_save:(NSError**)error rollbackOnError:(BOOL)rollbackOnError{
    BOOL result = [self save:error];
    if(!result){
        [self rollback];
    }
    return result;
}

@end
