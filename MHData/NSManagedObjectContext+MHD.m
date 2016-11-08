//
//  NSManagedObjectContext+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSManagedObjectContext+MHD.h"
#import "MHDError.h"
#import "NSPersistentStoreCoordinator+MHD.h"
#import <objc/runtime.h>

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

- (NSManagedObjectContext *)mhd_createChildContext{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:self.concurrencyType];
    context.parentContext = self;
    return context;
}

- (NSManagedObjectContext *)mhd_newBackgroundContextWithError:(NSError **)error {
    
    // Use the same store and model, but for maximum performance use a new persistent store coordinator for the context.
    NSPersistentStoreCoordinator *coordinator;
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
    NSPersistentStore* store = self.persistentStoreCoordinator.persistentStores.firstObject;
    NSURL* storeURL = store.URL;
    if(!storeURL){
        if(error){
            *error = [NSError errorWithDomain:MHDataErrorDomain code:MHDErrorInvalidArguments userInfo:@{NSLocalizedDescriptionKey : @"This context's coordinator store did not have a URL",
                                                                              NSLocalizedFailureReasonErrorKey : @"It was nil."}];
        }
        return nil;
    }
    
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.persistentStoreCoordinator.managedObjectModel];
    
    if (![coordinator addPersistentStoreWithType:store.type
                                   configuration:store.configurationName
                                                  URL:storeURL
                                              options:store.options
                                                error:error]) {
        return nil;
    }
#else
    // Since iOS 10 there is now a propert connection pool.
    // https://developer.apple.com/library/content/releasenotes/General/WhatNewCoreData2016/ReleaseNotes.html
    coordinator = self.persistentStoreCoordinator;
#endif
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    // Contrary to the Earthquakes populating from background queue example:
    // "Setter methods on queue-based managed object contexts are thread-safe. You can invoke these methods directly on any thread." From:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Reference/CoreDataFramework/Classes/NSManagedObjectContext_Class/index.html
    context.persistentStoreCoordinator = coordinator;

    // Pre-sierra OS X had an undo manager, ensure it's off for a performance benefit. On iOS its always been nil.
    context.undoManager = nil;

    return context;
}

- (NSArray *)mhd_fetchObjectsWithEntityName:(NSString*)entityName predicate:(nullable NSPredicate*)predicate error:(NSError**)error{
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
    fetchRequest.predicate = predicate;
    return [self executeFetchRequest:fetchRequest error:error];
}

- (NSArray *)mhd_fetchObjectsWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary error:(NSError**)error{
    // build the and predicate using the dict that also checks nulls.
    NSMutableArray* array = [NSMutableArray array];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [array addObject:[NSPredicate predicateWithFormat:@"%K = %@", key, obj]];
    }];
    NSCompoundPredicate* predicate = [NSCompoundPredicate andPredicateWithSubpredicates:array];
    return [self mhd_fetchObjectsWithEntityName:entityName predicate:predicate error:error];
}

-(NSManagedObject*)mhd_fetchOrInsertObjectWithEntityName:(NSString*)entityName dictionary:(NSDictionary*)dictionary inserted:(BOOL*)inserted error:(NSError**)error{
    NSError* e;
    
    // initialize inserted
    if(inserted){
        *inserted = NO;
    }
    
    NSArray* objects = [self mhd_fetchObjectsWithEntityName:entityName dictionary:dictionary error:&e];
    if(!objects){
        // nil pointer check
        if(error){
            *error = e;
        }
        return nil;
    }
    NSManagedObject *object = objects.firstObject;
    if(!object){
        object = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self];
        [object setValuesForKeysWithDictionary:dictionary];
        // nil pointer check
        if(inserted){
            *inserted = YES;
        }
    }
    return object;
}

-(id)mhd_fetchValueForAggregateFunction:(NSString*)function attributeName:(NSString*)attributeName entityName:(NSString*)entityName predicate:(nullable NSPredicate*)predicate error:(NSError**)error{
    // todo validate these
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self];
    NSAttributeDescription *attribute = entity.attributesByName[attributeName];
    
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
    fetchRequest.predicate = predicate;
    
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

- (BOOL)mhd_save:(NSError**)error undoParentOnError:(BOOL)undoParentOnError{
    NSUndoManager *undoManager;
    if(undoParentOnError){
        if(!self.parentContext.undoManager){
            undoManager = [[NSUndoManager alloc] init];
            self.parentContext.undoManager = undoManager;
        }
        [self.parentContext.undoManager beginUndoGrouping];
    }
    BOOL result = [self save:error];
    if(!result){
        if(undoParentOnError){
            [self.parentContext.undoManager endUndoGrouping];
            [self.parentContext.undoManager undo];
            if(undoManager){
                self.parentContext.undoManager = nil;
            }
        }
    }
    return result;
}

- (void)mhd_setAutomaticallyMergesChangesFromParent:(BOOL)automatically {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    self.automaticallyMergesChangesFromParent = automatically;
#else
    [self performBlockAndWait:^{
        // preventing adding a duplicate observer
        if (automatically != self.mhd_automaticallyMergesChangesFromParent) {
            objc_setAssociatedObject(self, @selector(mhd_automaticallyMergesChangesFromParent), @(automatically), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            if (automatically) {
                // parentContext might be nil which will result in this observing all contexts so require another check in the method.
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mhd_automaticallyMergeChangesFromContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
            } else {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:self.parentContext];
            }
        }
    }];
#endif
    
}

- (BOOL)mhd_automaticallyMergesChangesFromParent {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    return self.automaticallyMergesChangesFromParent;
#else
    __block BOOL value;
    [self performBlockAndWait:^{
        value = [objc_getAssociatedObject(self, @selector(mhd_automaticallyMergesChangesFromParent)) boolValue];
    }];
    return value;
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000
- (void)mhd_automaticallyMergeChangesFromContextDidSaveNotification:(NSNotification *)notification {
    // this context could be the parent or any context.
    NSManagedObjectContext *context = (NSManagedObjectContext *)notification.object;
    // ignore if its the same context
    if(context == self){
        return;
    }
    // ignore if it has a parent and our parent isn't it.
    else if(context.parentContext && self.parentContext != context){
        return;
    }
    // ignore if its using a different store.
    else if (![context.persistentStoreCoordinator.persistentStores.firstObject.URL isEqual:self.persistentStoreCoordinator.persistentStores.firstObject.URL]) {
        return;
    }
    
    [self performBlock:^{
        for (NSManagedObject *updatedObject in notification.userInfo[NSUpdatedObjectsKey]) {
            // fault
            [[self objectWithID:updatedObject.objectID] willAccessValueForKey:nil];
        }
        [self mergeChangesFromContextDidSaveNotification:notification];
    }];
}
#endif

- (NSOperation *)mhd_operationPerformingBlockAndWait:(void (^)())block{
    return [NSBlockOperation blockOperationWithBlock:^{
        [self performBlockAndWait:block];
    }];
}

@end
