//
//  NSEntityDescription+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSEntityDescription (MHD)

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mhd_toManyRelationshipsByName;

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mhd_toOneRelationshipsByName;

// test
- (NSArray<NSRelationshipDescription *> *)mhd_relationshipsWithManagedObjectClass:(Class)managedObjectClass;

// convenience for getting only relations that have toMany true.
-(NSArray*)mhd_toManyRelationships;

-(NSArray*)mhd_toOneRelationships;

// e.g. if this entity is FruitType it would return fruitTypes. It lowercases first letter and appends an 's'. Todo move to camelCaseAndPluralize
- (NSString*)mhd_propertyNameForToManyRelation;

- (NSArray*)mhd_transientProperties;

@end

NS_ASSUME_NONNULL_END