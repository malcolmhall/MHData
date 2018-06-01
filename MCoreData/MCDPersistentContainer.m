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

@interface NSPersistentStoreCoordinator ()

@property (weak, nonatomic, readwrite, setter=mcd_setPersistentContainer:) MCDPersistentContainer *mcd_persistentContainer;

@end

@implementation MCDPersistentContainer

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super initWithName:name managedObjectModel:model];
    if (self) {
        self.persistentStoreCoordinator.mcd_persistentContainer = self;
    }
    return self;
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

@implementation NSPersistentStoreCoordinator (MCDPersistentContainer)

- (MCDPersistentContainer *)mcd_persistentContainer{
    return objc_getAssociatedObject(self, @selector(mcd_persistentContainer));
}

- (void)mcd_setPersistentContainer:(MCDPersistentContainer *)persistentContainer{
    if(self.mcd_persistentContainer){
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Coordinator already has a container; cannot replace." userInfo:nil];
    }
    objc_setAssociatedObject(self, @selector(mcd_persistentContainer), persistentContainer, OBJC_ASSOCIATION_ASSIGN);
}

@end
