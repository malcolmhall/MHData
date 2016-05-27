//
//  NSEntityDescription+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define MH_toManyRelationshipsByName MHDATA_ADD_PREFIX(MH_toManyRelationshipsByName)
#define MH_toOneRelationshipsByName MHDATA_ADD_PREFIX(MH_toOneRelationshipsByName)
#define MH_relationshipsWithManagedObjectClass MHDATA_ADD_PREFIX(MH_relationshipsWithManagedObjectClass)
#define MH_toManyRelationships MHDATA_ADD_PREFIX(MH_toManyRelationships)
#define MH_toOneRelationships MHDATA_ADD_PREFIX(MH_toOneRelationships)
#define MH_propertyNameForToManyRelation MHDATA_ADD_PREFIX(MH_propertyNameForToManyRelation)
#define MH_transientProperties MHDATA_ADD_PREFIX(MH_transientProperties)


NS_ASSUME_NONNULL_BEGIN

@interface NSEntityDescription (MH)

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *MH_toManyRelationshipsByName;

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *MH_toOneRelationshipsByName;

// test
- (NSArray<NSRelationshipDescription *> *)MH_relationshipsWithManagedObjectClass:(Class)managedObjectClass;

// convenience for getting only relations that have toMany true.
-(NSArray*)MH_toManyRelationships;

-(NSArray*)MH_toOneRelationships;

// e.g. if this entity is FruitType it would return fruitTypes. It lowercases first letter and appends an 's'. Todo move to camelCaseAndPluralize
- (NSString*)MH_propertyNameForToManyRelation;

- (NSArray*)MH_transientProperties;

@end

NS_ASSUME_NONNULL_END