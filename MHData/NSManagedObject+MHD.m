//
//  NSManagedObject+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSManagedObject+MHD.h"

@implementation NSManagedObject (MHD)

- (id)objectForKeyedSubscript:(NSString*)key {
    return [self valueForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    NSParameterAssert([(id<NSObject>)key isKindOfClass:[NSString class]]);
    [self setValue:object forKey:(NSString*)key];
}

-(instancetype)mhd_initWithContext:(NSManagedObjectContext*)context{
    // search for this class in the model to find the entity
    NSEntityDescription* entity;
    NSString* className = NSStringFromClass(self.class);
    for(NSEntityDescription* e in context.persistentStoreCoordinator.managedObjectModel.entities){
        if([entity.managedObjectClassName isEqualToString:className]){
            entity = e;
            break;
        }
        // we won't check if there are any more
    }
    if(!entity){
        NSLog(@"Could not find an entity for this class");
        abort();
    }
    return [self initWithEntity:entity insertIntoManagedObjectContext:context];
}

@end
