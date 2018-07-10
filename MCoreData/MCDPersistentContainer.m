//
//  MCDPersistentContainer.m
//  MCoreData
//
//  Created by Malcolm Hall on 22/05/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDPersistentContainer.h"
#import "NSPersistentStoreCoordinator+MCDPrivate.h"
#import <objc/runtime.h>

//@interface NSPersistentStoreCoordinator ()
//
//@property (weak, nonatomic, readwrite, setter=mcd_setPersistentContainer:) MCDPersistentContainer *mcd_persistentContainer;
//
//@end

@implementation MCDPersistentContainer

- (MCDManagedObjectContext *)viewContext{
    NSManagedObjectContext *moc = super.viewContext;
    if(![moc isKindOfClass:MCDManagedObjectContext.class]){
        return nil;
    }
    return (MCDManagedObjectContext *)moc;
}

- (MCDManagedObjectContext *)newBackgroundContext{
    return [self newBackgroundContextWithClass:MCDManagedObjectContext.class];
}

- (MCDManagedObjectContext *)newViewContext{
    return [self newViewContextWithClass:MCDManagedObjectContext.class];
}

void validateClassParam(Class<MCDManagedObjectContext> managedObjectContextClass){
    if(![managedObjectContextClass conformsToProtocol:@protocol(MCDManagedObjectContext)]){
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Class does not conform to MCDManagedObjectContext." userInfo:nil];
    }
}

- (__kindof MCDManagedObjectContext *)newViewContextWithClass:(Class<MCDManagedObjectContext>)managedObjectContextClass{
    validateClassParam(managedObjectContextClass);
    MCDManagedObjectContext *moc = [managedObjectContextClass.alloc initWithConcurrencyType:NSMainQueueConcurrencyType persistentContainer:self];
    moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
    return moc;
}

- (__kindof MCDManagedObjectContext *)newBackgroundContextWithClass:(Class<MCDManagedObjectContext>)managedObjectContextClass{
    validateClassParam(managedObjectContextClass);
    if(!self.persistentStoreCoordinator.persistentStores.count){
        NSLog(@"Background context created for persistent container %@ with no stores loaded", self.name);
    }
    MCDManagedObjectContext *moc = [managedObjectContextClass.alloc initWithConcurrencyType:NSPrivateQueueConcurrencyType persistentContainer:self];
    if(self.viewContext.parentContext){
        moc.parentContext = self.viewContext.parentContext;
    }
    else{
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    return moc;
}

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super initWithName:name managedObjectModel:model];
    if (self) {
        [self setValue:self.newViewContext forKey:@"_viewContext"];
        //self.persistentStoreCoordinator.mcd_persistentContainer = self;
    }
    return self;
}

- (instancetype)init{
    return [self initWithName:[NSBundle.mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey]];
}

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

@end

//@implementation NSPersistentStoreCoordinator (MCDPersistentContainer)
//
//- (MCDPersistentContainer *)mcd_persistentContainer{
//    return objc_getAssociatedObject(self, @selector(mcd_persistentContainer));
//}
//
//- (void)mcd_setPersistentContainer:(MCDPersistentContainer *)persistentContainer{
//    if(self.mcd_persistentContainer){
//        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Coordinator already has a container; cannot replace." userInfo:nil];
//    }
//    objc_setAssociatedObject(self, @selector(mcd_persistentContainer), persistentContainer, OBJC_ASSOCIATION_ASSIGN);
//}
//
//@end

//@implementation NSManagedObjectContext (MCDPersistentContainer)
//
//- (MCDPersistentContainer *)mcd_persistentContainer{
//    return self.persistentStoreCoordinator.mcd_persistentContainer;
//}
//
//@end
