//
//  MHDPersistentStoreDescription.m
//  MHData
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDPersistentStoreDescription.h"

@implementation MHDPersistentStoreDescription{
    NSMutableDictionary<NSString *, NSObject *> *_options;
}

+ (instancetype)persistentStoreDescriptionWithURL:(NSURL *)URL{
    return [[self alloc] initWithURL:URL];
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _options = [NSMutableDictionary dictionaryWithObjectsAndKeys:@YES, NSInferMappingModelAutomaticallyOption,
                           @YES, NSMigratePersistentStoresAutomaticallyOption,
                           nil];
        self.type = NSSQLiteStoreType;
        self.URL = URL;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithURL:[NSURL fileURLWithPath:@"/dev/null"]];
}

- (void)setOption:(NSObject *)option forKey:(NSString *)key{
    _options[key] = option;
}

- (void)setValue:(nullable NSObject *)value forPragmaNamed:(NSString *)name{
    
}

@end
