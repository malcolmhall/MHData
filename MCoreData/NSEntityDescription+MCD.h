//
//  NSEntityDescription+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSEntityDescription (MCD)

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mcd_toManyRelationshipsByName;

@property (readonly, copy) NSDictionary<NSString *, NSRelationshipDescription *> *mcd_toOneRelationshipsByName;

// test
- (NSArray<NSRelationshipDescription *> *)mcd_relationshipsWithManagedObjectClass:(Class)managedObjectClass;

// convenience for getting only relations that have toMany true.
-(NSArray*)mcd_toManyRelationships;

-(NSArray*)mcd_toOneRelationships;

// e.g. if this entity is FruitType it would return fruitTypes. It lowercases first letter and appends an 's'. Todo move to camelCaseAndPluralize
- (NSString*)mcd_propertyNameForToManyRelation;

- (NSArray*)mcd_transientProperties;

@end

NS_ASSUME_NONNULL_END
