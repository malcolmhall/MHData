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
#import "NSManagedObjectContext+MHD.h"

//#if __IPHONE_OS_VERSION_MAX_ALLOWED < 100000

@implementation MHDPersistentContainer

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
+(BOOL)classAvailable{
    static NSString* sdkVersion = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // if the class exists and we linked against the SDK it became available in.
        NSString* sdkName = [[NSBundle bundleForClass:[self class]] objectForInfoDictionaryKey:@"DTSDKName"];
        sdkVersion = [sdkName stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]];
    });
    return sdkVersion.integerValue >= 10;
}

+(id)alloc{
    if([self classAvailable]){
        return [NSPersistentContainer alloc];
    }
    return [super alloc];
}
#endif

+ (NSURL *)defaultDirectoryURL{
    #if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
    if([self classAvailable]){
        return [NSPersistentContainer defaultDirectoryURL];
    }
    #endif
    
    NSError* error;
    NSURL* URL = [NSPersistentStoreCoordinator mhd_applicationSupportDirectoryWithError:&error];
    if(!URL){
        NSLog(@"%@", error.description);
        abort();
    }
    return URL;
}

+ (instancetype)persistentContainerWithName:(NSString *)name{
    return [[self alloc] initWithName:name];
}

+ (instancetype)persistentContainerWithName:(NSString *)name managedObjectModel:(NSManagedObjectModel *)model{
    return [[self alloc] initWithName:name managedObjectModel:model];
}

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

- (void)loadPersistentStoresWithCompletionHandler:(void (^)(MHDPersistentStoreDescription *, NSError * _Nullable))block{
    for(MHDPersistentStoreDescription *sd in _persistentStoreDescriptions){
        [_persistentStoreCoordinator mhd_addPersistentStoreWithDescription:sd completionHandler:block];
    }
}

- (NSManagedObjectContext *)newBackgroundContext{
    NSError* error;
    NSManagedObjectContext* context = [self.viewContext mhd_newBackgroundContextWithError:&error];
    if(!context){
        // shouldn't happen
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to create background context" userInfo:error.userInfo];
    }
    return context;
}

- (void)performBackgroundTask:(void (^)(NSManagedObjectContext *))block{
    NSManagedObjectContext* bc = [self newBackgroundContext];
    [bc performBlock:^{
        block(bc);
    }];
}

@end

//#endif
