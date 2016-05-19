//
//  NSPersistentStoreCoordinator+MH.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <MHData/NSPersistentStoreCoordinator+MH.h>
#import <MHData/MHDataDefines.h>
#import <MHData/NSManagedObjectModel+MH.h>

@implementation NSPersistentStoreCoordinator (MH)

+(NSPersistentStoreCoordinator*)MH_defaultCoordinatorWithError:(NSError**)error{
    static NSPersistentStoreCoordinator* psc = nil;
    if(!psc){
        NSURL* url = [NSPersistentStoreCoordinator MH_defaultStoreURLWithError:error];
        if(!url){
            return nil;
        }
        psc = [NSPersistentStoreCoordinator MH_coordinatorWithManagedObjectModel:[NSManagedObjectModel MH_defaultModel] storeURL:url error:error];
        if(!psc){
            return nil;
        }
    }
    return psc;
}

//+ (NSPersistentStoreCoordinator*)MH_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model{
//    return [self MH_coordinatorWithManagedObjectModel:model storeURL:[self MH_def] error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
//}

+ (NSPersistentStoreCoordinator*)MH_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL*)storeURL error:(NSError**)error{
    NSPersistentStoreCoordinator* psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    if(![psc MH_addStoreWithURL:storeURL error:error]){
        return nil;
    }
    return psc;
}

//+(NSPersistentStoreCoordinator*)MH_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL{
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
//        psc = [self MH_persistentStoreCoordinatorWithSQLiteStoreURL:SQLiteStoreURL managedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
//        [_persistentStoreCoordinators setObject:psc forKey:SQLiteStoreURL];
//    }
//
//    return psc;
//}


-(NSPersistentStore*)MH_addStoreWithURL:(NSURL*)storeURL error:(NSError**)error{
    
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

+(NSString*)MH_defaultStoreFilename{
    return [[NSBundle mainBundle].bundleIdentifier stringByAppendingString:@".sqlite"];
}

+(NSURL *)MH_defaultStoreURLWithError:(NSError**)error{
    NSURL* dir = [self MH_applicationSupportDirectoryWithError:error]; // if nil then method returns nil.
    return [dir URLByAppendingPathComponent:[self MH_defaultStoreFilename]];
}

+ (NSURL *)MH_applicationSupportDirectoryWithError:(NSError**)error{
    
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
                *error = [NSError errorWithDomain:MHDataErrorDomain code:101 userInfo:@{NSLocalizedDescriptionKey : @"Could not access the application data folder",
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
