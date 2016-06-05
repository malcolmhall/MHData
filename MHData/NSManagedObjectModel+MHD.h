//
//  NSManagedObjectModel+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectModel (MHD)

// merged model of all models in bundle.

+ (NSManagedObjectModel*)mhd_defaultModel;

// Easily load a model from a model file and caches it. Do not include any file extension.
+ (NSManagedObjectModel*)mhd_modelNamed:(NSString*)name;

-(NSEntityDescription*)mhd_entityNamed:(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END