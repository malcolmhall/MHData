//
//  NSManagedObjectModel+MH.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <MHData/NSManagedObjectModel+MH.h>

@implementation NSManagedObjectModel (MH)

+(NSManagedObjectModel*)mh_defaultModel{
    static NSManagedObjectModel* _defaultModel = nil;
    if(!_defaultModel){
        NSManagedObjectModel* mom = [NSManagedObjectModel mergedModelFromBundles:nil];
        if(!mom.entities.count){
            [NSException raise:NSInternalInconsistencyException format:@"No entities found in default model."];
        }
        _defaultModel = mom;
    }
    return _defaultModel;
}

//helper for load model files
+(NSManagedObjectModel*)mh_modelNamed:(NSString *)name{
    NSString* s = [[NSBundle mainBundle] pathForResource:name ofType:@"momd"]; // mom is what it gets compiled to on the phone.
    if(!s){
        s = [[NSBundle mainBundle] pathForResource:name ofType:@"mom"]; // mom is what it gets compiled to on the phone.
    }
    if(!s){
        [NSException raise:@"Invalid model name" format:@"model named %@ is invalid", name];
    }
    NSURL* url = [NSURL fileURLWithPath:s];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
}

-(NSEntityDescription*)mh_entityNamed:(NSString*)entityName{
    return self.entitiesByName[entityName];
}

@end
