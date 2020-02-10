//
//  NSPersistentStoreCoordinator+MCD.m
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSPersistentStoreCoordinator+MCD.h"
#import "MCDError.h"
#import "NSManagedObjectModel+MCD.h"
#import "MCDNSPersistentStoreDescription.h"
#import <objc/runtime.h>

@implementation NSPersistentStoreCoordinator (MCD)

+ (NSPersistentStoreCoordinator*)mcd_defaultCoordinatorWithError:(NSError **)error{
    static NSPersistentStoreCoordinator* psc = nil;
    if(!psc){
        NSURL *url = [NSPersistentStoreCoordinator mcd_defaultStoreURLWithError:error];
        if(!url){
            return nil;
        }
        psc = [NSPersistentStoreCoordinator mcd_coordinatorWithManagedObjectModel:NSManagedObjectModel.mcd_defaultModel storeURL:url error:error];
        if(!psc){
            return nil;
        }
    }
    return psc;
}

//+ (NSPersistentStoreCoordinator*)mcd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model{
//    return [self mcd_coordinatorWithManagedObjectModel:model storeURL:[self mcd_def] error:<#(NSError * _Nullable __autoreleasing * _Nullable)#>]
//}

+ (NSPersistentStoreCoordinator *)mcd_coordinatorWithManagedObjectModel:(NSManagedObjectModel *)model storeURL:(NSURL *)storeURL error:(NSError **)error{
    NSPersistentStoreCoordinator *psc = [NSPersistentStoreCoordinator.alloc initWithManagedObjectModel:model];
    if(![psc mcd_addStoreWithURL:storeURL error:error]){
        return nil;
    }
    return psc;
}

//+ (NSPersistentStoreCoordinator*)mcd_sharedPersistentStoreCoordinatorWithSQLiteStoreURL:(NSURL*)SQLiteStoreURL{
//    static NSMutableDictionary *persistentStoreCoordinators;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        persistentStoreCoordinators = NSMutableDictionary.new;
//    });
//    @synchronized(persistentStoreCoordinators){
//        NSPersistentStoreCoordinator* psc = [persistentStoreCoordinators objectForKey:SQLiteStoreURL];
//        if(!psc){
//              psc = [self mcd_persistentStoreCoordinatorWithSQLiteStoreURL:SQLiteStoreURL managedObjectModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
//             [persistentStoreCoordinators setObject:psc forKey:SQLiteStoreURL];
//        }
//        return psc;
//     }
//}


- (NSPersistentStore*)mcd_addStoreWithURL:(NSURL*)storeURL error:(NSError **)error{
    
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
        [NSFileManager.defaultManager removeItemAtURL:storeURL error:nil];
        
        // try again
        store = [self addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:error];
#endif
    }
    return store;
}

+ (NSString *)mcd_defaultStoreFilename{
    return [[NSBundle mainBundle].bundleIdentifier stringByAppendingString:@".sqlite"];
}

+ (NSURL *)mcd_defaultStoreURLWithError:(NSError **)error{
    NSURL *dir = [self mcd_applicationSupportDirectoryWithError:error]; // if nil then method returns nil.
    return [dir URLByAppendingPathComponent:self.mcd_defaultStoreFilename];
}

+ (NSURL *)mcd_applicationSupportDirectoryWithError:(NSError **)error{
    
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSURL *URL = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;
    
    NSError *e;
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
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey : @"Could not access the application data folder", NSLocalizedFailureReasonErrorKey : @"Found a file in its place"};
            *error = [NSError errorWithDomain:MCoreDataErrorDomain code:101 userInfo:userInfo];
        }
        return nil;
    }
    
    return URL;
}

- (void)mcd_addPersistentStoreWithDescription:(MCDNSPersistentStoreDescription *)storeDescription completionHandler:(void (^)(MCDNSPersistentStoreDescription *, NSError * _Nullable))block{
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

- (BOOL)mcd_destroyPersistentStore:(NSPersistentStore *)store error:(NSError * _Nullable __autoreleasing *)error{
    return [self destroyPersistentStoreAtURL:store.URL withType:store.type options:store.options error:error];
}

/*
- (NSPersistentStoreDescription *)storeDescription{
    return self.persistentStoreDescriptions.firstObject;
}

- (NSURL *)storeURL{
    return self.storeDescription.URL;
}

- (NSURL *)backupsDirectoryURL{
    return [self.storeURL.URLByDeletingLastPathComponent URLByAppendingPathComponent:@"Backups"];
}

- (NSDictionary *)storeOptions{
    return self.storeDescription.options;
}

- (void)backupPersistentStore{
    NSLog(@"Backing up persistent store");
    NSURL *storeURL = self.storeURL;
    NSDateFormatter *formatter = NSDateFormatter.alloc.init;
    formatter.dateFormat = @"yyyy-MM-dd_HH-mm-ss";
    NSString *s = [formatter stringFromDate:NSDate.date];
    s = [NSString stringWithFormat:@"Backup-%@-%@", s, NSUUID.UUID.UUIDString];
    NSURL *backupsURL = [self.backupsDirectoryURL URLByAppendingPathComponent:s];
    NSURL *storeBackupURL = [backupsURL URLByAppendingPathComponent:storeURL.lastPathComponent];
    NSError *error;
    if(![NSFileManager.defaultManager createDirectoryAtURL:backupsURL withIntermediateDirectories:YES attributes:nil error:&error]){
        NSLog(@"Failed to create database backup directory: %@", error);
        error = nil;
    }
    if(![self.persistentStoreCoordinator replacePersistentStoreAtURL:storeBackupURL destinationOptions:self.storeOptions withPersistentStoreFromURL:storeURL sourceOptions:self.storeOptions storeType:NSSQLiteStoreType error:&error]){
        NSLog(@"Error backing up old persistent store: %@", error);
        return;
    }
    NSLog(@"Backed up old persistent store from %@ to %@", storeURL, storeBackupURL);
    if(![storeURL checkResourceIsReachableAndReturnError:&error]){
        NSLog(@"Backed up store and the old one is gone");
        return;
    }
    NSLog(@"Destroying old persistent store at %@", storeURL);
    if(![self.persistentStoreCoordinator destroyPersistentStoreAtURL:storeURL withType:NSSQLiteStoreType options:self.storeOptions error:&error]){
        NSLog(@"Error destroying persistent store: %@", error);
        return;
    }
    NSLog(@"Destroyed persistent store at %@", storeURL);
}
*/

@end
