//
//  NSEntityDescription+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

#define mh_toManyRelationshipsByName MHDATA_ADD_PREFIX(mh_toManyRelationshipsByName)
#define mh_toOneRelationshipsByName MHDATA_ADD_PREFIX(mh_toOneRelationshipsByName)
#define mh_relationshipsWithManagedObjectClass MHDATA_ADD_PREFIX(mh_relationshipsWithManagedObjectClass)
#define mh_toManyRelationships MHDATA_ADD_PREFIX(mh_toManyRelationships)
#define mh_toOneRelationships MHDATA_ADD_PREFIX(mh_toOneRelationships)
#define mh_propertyNameForToManyRelation MHDATA_ADD_PREFIX(mh_propertyNameForToManyRelation)
#define mh_transientProperties MHDATA_ADD_PREFIX(mh_transientProperties)


NS_ASSUME_NONNULL_BEGIN

@interface NSEntityDescription (MH)

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mh_toManyRelationshipsByName;

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mh_toOneRelationshipsByName;

// test
- (NSArray<NSRelationshipDescription *> *)mh_relationshipsWithManagedObjectClass:(Class)managedObjectClass;

// convenience for getting only relations that have toMany true.
-(NSArray*)mh_toManyRelationships;

-(NSArray*)mh_toOneRelationships;

// e.g. if this entity is FruitType it would return fruitTypes. It lowercases first letter and appends an 's'. Todo move to camelCaseAndPluralize
- (NSString*)mh_propertyNameForToManyRelation;

- (NSArray*)mh_transientProperties;

@end

NS_ASSUME_NONNULL_END