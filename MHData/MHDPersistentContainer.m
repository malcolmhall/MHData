//
//  MHDPersistentContainer.m
//  MHData
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDPersistentContainer.h"
#import "MHDPersistentStoreDescription.h"
#import "NSPersistentStoreCoordinator+MHD.h"

@implementation MHDPersistentContainer

- (instancetype)initWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model
{
    self = [super init];
    if (self) {
        _name = name.copy; // copy on way in?
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        _viewContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _viewContext.persistentStoreCoordinator = _persistentStoreCoordinator;
        NSURL* URL = [[[self class] defaultDirectoryURL] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", name]];
        _persistentStoreDescriptions = @[[MHDPersistentStoreDescription persistentStoreDescriptionWithURL:URL]];
    }
    return self;
}

-(NSManagedObjectModel*)managedObjectModel{
    return _persistentStoreCoordinator.managedObjectModel;
}

- (instancetype)initWithName:(NSString *)name{
    NSURL* modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    if(!modelURL){
        modelURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"mom"]; // mom is what it gets compiled to on the phone.
    }
    
    NSManagedObjectModel* model;
    if(modelURL){
        model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    else{
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    return [self initWithName:name managedObjectModel:model];
}

+ (NSURL *)defaultDirectoryURL{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *URL = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask].firstObject;
    if(![fileManager createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:nil]){
        abort();
    }
    return URL;
}

- (void)loadPersistentStoresWithCompletionHandler:(void (^)(MHDPersistentStoreDescription *, NSError * _Nullable))block{
    for(MHDPersistentStoreDescription* sd in _persistentStoreDescriptions){
        [_persistentStoreCoordinator mhd_addPersistentStoreWithDescription:sd completionHandler:^(MHDPersistentStoreDescription *storeDescription, NSError *error) {
            block(storeDescription, error);
        }];
    }
}

- (NSManagedObjectContext *)newBackgroundContext{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = _persistentStoreCoordinator;
    return context;
}

@end
