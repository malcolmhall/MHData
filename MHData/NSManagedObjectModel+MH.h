//
//  NSManagedObjectModel+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define mh_defaultModel MHDATA_ADD_PREFIX(mh_defaultModel)
#define mh_modelNamed MHDATA_ADD_PREFIX(mh_modelNamed)
#define mh_entityNamed MHDATA_ADD_PREFIX(mh_entityNamed)

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectModel (MH)

// merged model of all models in bundle.

+ (NSManagedObjectModel*)mh_defaultModel;

// Easily load a model from a model file and caches it. Do not include any file extension.
+ (NSManagedObjectModel*)mh_modelNamed:(NSString*)name;

-(NSEntityDescription*)mh_entityNamed:(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END