//
//  NSManagedObjectModel+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectModel (MHD)

// merged model of all models in bundle.

+ (NSManagedObjectModel*)mhd_defaultModel;

// Easily load a model from a model file and caches it. Do not include any file extension.
+ (NSManagedObjectModel*)mhd_modelNamed:(NSString*)name;

// Returns the entity in the model without copying it which is what entityByName does, this allows it to be mutated.
- (NSEntityDescription*)mhd_entityNamed:(NSString*)entityName;

@end

NS_ASSUME_NONNULL_END