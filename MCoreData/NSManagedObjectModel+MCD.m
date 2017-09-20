//
//  NSManagedObjectModel+MCD.m
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSManagedObjectModel+MCD.h"

@implementation NSManagedObjectModel (MCD)

+ (NSManagedObjectModel *)mcd_defaultModel{
    static NSManagedObjectModel *defaultModel = nil;
    if(!defaultModel){
        NSManagedObjectModel* mom = [NSManagedObjectModel mergedModelFromBundles:nil];
        if(!mom.entities.count){
            [NSException raise:NSInternalInconsistencyException format:@"No entities found in default model."];
        }
        defaultModel = mom;
    }
    return defaultModel;
}

//helper for load model files
+ (NSManagedObjectModel *)mcd_modelNamed:(NSString *)name{
    NSString *s = [NSBundle.mainBundle pathForResource:name ofType:@"momd"]; // mom is what it gets compiled to on the phone.
    if(!s){
        s = [NSBundle.mainBundle pathForResource:name ofType:@"mom"]; // mom is what it gets compiled to on the phone.
    }
    if(!s){
        [NSException raise:@"Invalid model name" format:@"model named %@ is invalid", name];
    }
    NSURL *url = [NSURL fileURLWithPath:s];
    return [NSManagedObjectModel.alloc initWithContentsOfURL:url];
}

- (NSEntityDescription *)mcd_entityNamed:(NSString *)entityName{
    for(NSEntityDescription* entity in self.entities){
        if([entity.name isEqualToString:entityName]){
            return entity;
        }
    }
    return nil;
}

@end
