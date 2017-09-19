//
//  NSManagedObject+MCD.m
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSManagedObject+MCD.h"

@implementation NSManagedObject (MCD)

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self valueForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    NSParameterAssert([(id<NSObject>)key isKindOfClass:[NSString class]]);
    [self setValue:object forKey:(NSString *)key];
}

- (instancetype)mcd_initWithContext:(NSManagedObjectContext *)context{
    // search for this class in the model to find the entity
    NSEntityDescription* entity;
    NSString * className = NSStringFromClass(self.class);
    NSPersistentStoreCoordinator *psc = context.persistentStoreCoordinator;
    for(NSEntityDescription* e in psc.managedObjectModel.entities){
        if([e.managedObjectClassName isEqualToString:className]){
            entity = e;
            break;
        }
        // we won't check if there are any more matches
    }
    if(!entity){
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Could not find an entity for this class" userInfo:nil];
    }
    return [self initWithEntity:entity insertIntoManagedObjectContext:context];
}

@end
