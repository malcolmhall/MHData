//
//  NSPersistentStoreCoordinator+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSPersistentStoreCoordinator+MHD.h"
#import "MHDataErrors.h"
#import "NSManagedObjectModel+MHD.h"

@implementation NSPersistentStoreCoordinator (MHD)

+(NSPersistentStoreCoordinator*)mhd_defaultCoordinatorWithError:(NSError**)error{
    static NSPersistentStoreCoordinator* psc = nil;
    if(!psc){
        NSURL* url = [NSPersistentStoreCoordinator mhd_defaultStoreURLWithError:error];
        if(!url){
            return nil;
        }
        psc = [NSPersistentStoreCoordinator mhd_coordinatorWithManagedObjectModel:[NSManagedObjectModel mhd_defaultModel] storeURL:url error:error];
        if(!psc){
            return nil;
        }
    }
    return psc;
}

//+ (NSPersistentStoreCoordinator*)mhd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model{
//    return [self mhd_coordinatorWithManagedObjectModel:model storeURL:[self mhd_def] error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
//}

+ (NSPersistentStoreCoordinator*)mhd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error{
    NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if(![psc mhd_addStoreWithURL:storeURL error:error]){
        return nil;
    }
    return psc;
}

//+(NSPersistentStoreCoordinator*)mhd_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL{
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
//        psc = [self mhd_persistentStoreCoordinatorWithSQLiteStoreURL:SQLiteStoreURL managedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
//        [_persistentStoreCoordinators setObject:psc forKey:SQLiteStoreURL];
//    }
//
//    return psc;
//}


-(NSPersistentStore*)mhd_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error{
    
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @YES, NSMigratePersistentStoresAutomaticallyOption,
                                    @YES, NSInferMappingModelAutomaticallyOption,
                                    NSFileProtectionNone, NSPersistentStoreFileProtectionKey,
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

+(NSString*)mhd_defaultStoreFilename{
    return [[NSBundle mainBundle].bundleIdentifier stringByAppendingString:@".sqlite"];
}

+(NSURL *)mhd_defaultStoreURLWithError:(NSError**)error{
    NSURL* dir = [self mhd_applicationSupportDirectoryWithError:error]; // if nil then method returns nil.
    return [dir URLByAppendingPathComponent:[self mhd_defaultStoreFilename]];
}

+ (NSURL *)mhd_applicationSupportDirectoryWithError:(NSError**)error{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;
    
    NSError* e;
    NSDictionary *properties = [URL resourceValuesForKeys:@[NSURLIsDirectoryKey] error:&e];
    if (!properties) {
        // creates the folder if doesn't exist
        if (e.code == NSFileReadNoSuchFileError) {
            if(![fileManager createDirectoryAtPath:URL.path withIntermediateDirectories:YES attributes:nil error:&e]){
                if(error){
                    *error = e;
                }
                return nil;
            }
        }
        else{ // another error reading the resource values.
            if(error){
                *error = e;
            }
            return nil;
        }
    }
    // check it is a directory
    NSNumber *isDirectoryNumber = properties[NSURLIsDirectoryKey];
    if (isDirectoryNumber && !isDirectoryNumber.boolValue) {
        if(error){
            *error = [NSError errorWithDomain:MHDataErrorDomain code:101 userInfo:@{NSLocalizedDescriptionKey : @"Could not access the application data folder",
                                                                              NSLocalizedFailureReasonErrorKey : @"Found a file in its place"}];
        }
        return nil;
    }
    
    return URL;
}

- (void)mhd_addPersistentStoreWithDescription:(MHDPersistentStoreDescription *)storeDescription completionHandler:(void (^)(MHDPersistentStoreDescription *, NSError * _Nullable))block{
    if (storeDescription.shouldAddStoreAsynchronously) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSError *error;
            [self addPersistentStoreWithType:storeDescription.type configuration:storeDescription.configuration URL:storeDescription.URL options:storeDescription.options error:&error];
            if (block) {
                block(storeDescription, error);
            }
        });
    } else {
        NSError *error;
        [self addPersistentStoreWithType:storeDescription.type configuration:storeDescription.configuration URL:storeDescription.URL options:storeDescription.options error:&error];
        if (block) {
            block(storeDescription, error);
        }
    }
}

@end
