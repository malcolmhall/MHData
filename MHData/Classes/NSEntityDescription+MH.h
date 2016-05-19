//
//  NSEntityDescription+MH.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSEntityDescription (MH)

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *MH_toManyRelationshipsByName;

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *MH_toOneRelationshipsByName;

// test
- (NSArray<NSRelationshipDescription *> *)MH_relationshipsWithManagedObjectClass:(Class)managedObjectClass;

// convenience for getting only relations that have toMany true.
//-(NSArray*)MH_toManyRelations;

//-(NSSet*)MH_toManyRelationNames;

//-(NSArray*)MH_toOneRelations;

// e.g. if this entity is FruitType it would return fruitTypes. It lowercases first letter and appends an 's'.
- (NSString*)MH_propertyNameForToManyRelation;

- (NSArray*)MH_transientProperties;

@end

NS_ASSUME_NONNULL_END