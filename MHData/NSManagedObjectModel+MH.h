//
//  NSManagedObjectModel+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define MH_defaultModel MHDATA_ADD_PREFIX(MH_defaultModel)
#define MH_modelNamed MHDATA_ADD_PREFIX(MH_modelNamed)
#define MH_entityNamed MHDATA_ADD_PREFIX(MH_entityNamed)

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectModel (MH)

// merged model of all models in bundle.

+ (NSManagedObjectModel*)MH_defaultModel;

// Easily load a model from a model file and caches it. Do not include any file extension.
+ (NSManagedObjectModel*)MH_modelNamed:(NSString*)name;

-(NSEntityDescription*)MH_entityNamed:(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END