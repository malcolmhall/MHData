//
//  NSManagedObjectModel+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectModel (MH)

// merged model of all models in bundle.
#define MH_defaultModel MHDATA_ADD_PREFIX(MH_defaultModel)
+ (NSManagedObjectModel*)MH_defaultModel;

// Easily load a model from a model file and caches it. Do not include any file extension.
#define MH_modelNamed MHDATA_ADD_PREFIX(MH_modelNamed)
+ (NSManagedObjectModel*)MH_modelNamed:(NSString*)name;

#define MH_entityNamed MHDATA_ADD_PREFIX(MH_entityNamed)
-(NSEntityDescription*)MH_entityNamed:(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END