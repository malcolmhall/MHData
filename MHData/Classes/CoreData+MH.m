//
//  CoreData+MH.m
//  MHData
//
//  Created by Malcolm Hall on 20/06/2009.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "CoreData+MH.h"
#import <objc/runtime.h>

NSString *const ErrorDomain = @"MHCoreData";

@implementation NSManagedObjectContext(MH)

+ (instancetype)mh_defaultContextWithError:(NSError**)error{
    static NSManagedObjectContext* _defaultManagedObjectContext;
    if(!_defaultManagedObjectContext){
        NSPersistentStoreCoordinator* psc = [NSPersistentStoreCoordinator mh_defaultCoordinatorWithError:error];
        if(!psc){
            return nil;
        }
        _defaultManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _defaultManagedObjectContext.persistentStoreCoordinator = psc;
    };
    return _defaultManagedObjectContext;
}

+ (instancetype)mh_defaultContext{
    NSError* error;
    NSManagedObjectContext* context = [self mh_defaultContextWithError:&error];
    if(error){
        [NSException raise:NSInternalInconsistencyException format:@"Failed to create default context %@", error];
    }
    return context;
}


-(NSManagedObjectContext*)mh_createChildContext{
    NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:self.concurrencyType];
    context.parentContext = self;
    return context;
}

- (NSManagedObjectContext *)mh_createPrivateQueueContextWithError:(NSError **)error {
    
    // It uses the same store and model, but a new persistent store coordinator and context.
    NSPersistentStoreCoordinator *localCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.persistentStoreCoordinator.managedObjectModel];

    NSPersistentStore* store = self.persistentStoreCoordinator.persistentStores.firstObject;
    
    NSURL* storeURL = store.URL;
    if(!storeURL){
        if(error){
            *error = [NSError errorWithDomain:ErrorDomain code:101 userInfo:@{NSLocalizedDescriptionKey : @"Could not find the coordinator's first store URL",
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

-(NSManagedObject*)mh_insertNewObjectForEntityName:(NSString*)entityName{
    return  [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
}

-(NSEntityDescription*)mh_entityDescriptionForName:(NSString*)name{
    return [NSEntityDescription entityForName:name inManagedObjectContext:self];
}

 -(NSArray*)mh_fetchObjectsWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
     NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
     fetchRequest.predicate = predicateOrNil;
     return [self executeFetchRequest:fetchRequest error:error];
 }
 
 - (id)mh_fetchObjectWithEntityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
     NSArray* objects = [self mh_fetchObjectsWithEntityName:entityName predicate:predicateOrNil error:error];
     return objects.firstObject;
 }
 
 -(NSManagedObject*)mh_fetchObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error{
     // build the and predicate using the dict that also checks nulls.
     NSMutableArray* array = [NSMutableArray array];
     [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         [array addObject:[NSPredicate predicateWithFormat:@"%K = %@", key, obj]];
     }];
     NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
     return [self mh_fetchObjectWithEntityName:entityName predicate:predicate error:error];
}

-(NSManagedObject*)mh_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error{
    NSError* e;
    
    // initialize inserted
    if(inserted){
        *inserted = NO;
    }
    
    NSManagedObject* object = [self mh_fetchObjectWithEntityName:entityName dictionary:dictionary error:&e];
    if(e){
        // nil pointer check
        if(error){
            *error = e;
        }
        return nil;
    }
    else if(!object){
        object = [self mh_insertNewObjectForEntityName:entityName];
        [object setValuesForKeysWithDictionary:dictionary];
        // nil pointer check
        if(inserted){
            *inserted = YES;
        }
    }
    return object;
}

-(id)mh_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(NSPredicate*)predicateOrNil error:(NSError**)error{
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

- (BOOL)mh_save:(NSError**)error rollbackOnError:(BOOL)rollbackOnError{
    BOOL result = [self save:error];
    if(!result){
        [self rollback];
    }
    return result;
}

@end


@implementation NSPersistentStoreCoordinator(MH)

+(NSPersistentStoreCoordinator*)mh_defaultCoordinatorWithError:(NSError**)error{
    static NSPersistentStoreCoordinator* psc = nil;
    if(!psc){
        NSURL* url = [NSPersistentStoreCoordinator mh_defaultStoreURLWithError:error];
        if(!url){
            return nil;
        }
        psc = [NSPersistentStoreCoordinator mh_coordinatorWithManagedObjectModel:[NSManagedObjectModel MH_defaultModel] storeURL:url error:error];
        if(!psc){
            return nil;
        }
    }
    return psc;
}

//+ (NSPersistentStoreCoordinator*)mh_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model{
//    return [self mh_coordinatorWithManagedObjectModel:model storeURL:[self mh_def] error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
//}

+ (NSPersistentStoreCoordinator*)mh_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error{
    NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if(![psc mh_addStoreWithURL:storeURL error:error]){
        return nil;
    }
    return psc;
}

//+(NSPersistentStoreCoordinator*)mh_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL{
//    
//    static NSMutableDictionary* _persistentStoreCoordinators;
//    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _persistentStoreCoordinators = [[NSMutableDictionary alloc] init];
//    });
//    
//    NSPersistentStoreCoordinator* psc = [_persistentStoreCoordinators objectForKey:SQLiteStoreURL];
//    if(!psc){
//        psc = [self mh_persistentStoreCoordinatorWithSQLiteStoreURL:SQLiteStoreURL managedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
//        [_persistentStoreCoordinators setObject:psc forKey:SQLiteStoreURL];
//    }
//    
//    return psc;
//}


-(NSPersistentStore*)mh_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error{

    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @YES, NSMigratePersistentStoresAutomaticallyOption,
                                    @YES, NSInferMappingModelAutomaticallyOption,
                                    nil];
    NSPersistentStore* store;
#ifdef DEBUG
    // turn off WAL because it means can't see things in the sqlite file its all in a binary log file.
    NSDictionary *pragmaOptions = @{@"journal_mode" : @"DELETE"};
    options[NSSQLitePragmasOption] = pragmaOptions;
#endif
    NSLog(@"%@", storeURL.path);

    store = [self addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:error];
    if (!store) {
#ifdef DEBUG
        //todo: show modal uialert to delete it
        NSLog(@"Deleting old store because we are in debug anyway.");
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];

        // try again
        store = [self addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:error];
#endif
    }
    return store;
}

+(NSString*)mh_defaultStoreFilename{
    return [[NSBundle mainBundle].bundleIdentifier stringByAppendingString:@".sqlite"];
}

+(NSURL *)mh_defaultStoreURLWithError:(NSError**)error{
    NSURL* dir = [self mh_applicationSupportDirectoryWithError:error]; // if nil then method returns nil.
    return [dir URLByAppendingPathComponent:[self mh_defaultStoreFilename]];
}

+ (NSURL *)mh_applicationSupportDirectoryWithError:(NSError**)error{

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *URLs = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
    
    NSURL *URL = URLs[URLs.count - 1];
    URL = [URL URLByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"]];
    
    NSError* e;
    NSDictionary *properties = [URL resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&e];
    if (properties) {
        NSNumber *isDirectoryNumber = properties[NSURLIsDirectoryKey];
        
        if (isDirectoryNumber && !isDirectoryNumber.boolValue) {
            if(error){
                *error = [NSError errorWithDomain:ErrorDomain code:101 userInfo:@{NSLocalizedDescriptionKey : @"Could not access the application data folder",
                                                                                  NSLocalizedFailureReasonErrorKey : @"Found a file in its place"}];
            }
            return nil;
        }
    }
    else {
        if (e.code == NSFileReadNoSuchFileError) {
            if(![fileManager createDirectoryAtPath:URL.path withIntermediateDirectories:YES attributes:nil error:&e]){
                if(error){
                    *error = e;
                }
                return nil;
            }
        }
    }
    return URL;
}

@end

@implementation NSManagedObjectModel(MH)

+(NSManagedObjectModel*)MH_defaultModel{
    static NSManagedObjectModel* _defaultModel = nil;
    if(!_defaultModel){
        NSManagedObjectModel* mom = [NSManagedObjectModel mergedModelFromBundles:nil];
        if(!mom.entities.count){
            [NSException raise:NSInternalInconsistencyException format:@"No entities found in default model."];
        }
        _defaultModel = mom;
    }
    return _defaultModel;
}

//helper for load model files
+(NSManagedObjectModel*)mh_modelNamed:(NSString *)name{
    NSString* s = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"]; // mom is what it gets compiled to on the phone.
    if(!s){
        s = [[NSBundle mainBundle] pathForResource:name ofType:@"mom"]; // mom is what it gets compiled to on the phone.
    }
    if(!s){
        [NSException raise:@"Invalid model name" format:@"model named %@ is invalid", name];
    }
    NSURL* url = [NSURL fileURLWithPath:s];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
}

-(NSEntityDescription*)mh_entityNamed:(NSString*)entityName{
    return self.entitiesByName[entityName];
}

@end


@implementation NSEntityDescription (MH)

-(NSDictionary<NSString *, NSRelationshipDescription *> *)mh_toManyRelationshipsByName{
    NSArray* toManyRelationships = [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = YES"]];
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}


-(NSDictionary<NSString *, NSRelationshipDescription *> *)mh_toOneRelationshipsByName{
    NSArray* toManyRelationships = [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = NO"]];
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}

- (NSArray<NSRelationshipDescription *> *)relationshipsWithManagedObjectClass:(Class)managedObjectClass{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"managedObjectClass = %@", managedObjectClass]];
}

//-(NSArray*)mh_toManyRelations{
//    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isToMany = true"]];
//}
//
//-(NSSet*)mh_toManyRelationNames{
//    return [NSSet setWithArray:[self.mh_toManyRelations valueForKey:@"name"]];
//}

-(NSArray*)mh_transientProperties{
    return [self.properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isTransient = true"]];
}

//-(NSArray*)mh_toOneRelations{
//    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isToMany = false"]];
//}

-(NSString*)mh_propertyNameForToManyRelation{
    return [[self.name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[self.name substringToIndex:1].lowercaseString] stringByAppendingString:@"s"];
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

//@implementation NSRelationshipDescription (MH)
//
//-(BOOL)isInverseOfRelation:(NSRelationshipDescription*)relation{
//    if(self.cl)
//}
//
//@end
