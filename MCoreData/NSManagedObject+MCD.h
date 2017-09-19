//
//  NSManagedObject+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObject (MCD)

// getter
- (id)objectForKeyedSubscript:(NSString*)key;

// setter
- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key;

// finds the entity that has this class's name as its managedObjectClassName.
- (instancetype)mcd_initWithContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END
