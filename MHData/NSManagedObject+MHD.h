//
//  NSManagedObject+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (MHD)

// getter
- (id)objectForKeyedSubscript:(NSString*)key;

// setter
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

// finds the entity that has this class's name as its managedObjectClassName.
- (instancetype)mhd_initWithContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END