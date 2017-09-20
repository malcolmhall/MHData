//
//  NSEntityDescription+MCD.m
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import "NSEntityDescription+MCD.h"

@implementation NSEntityDescription (MCD)

- (NSDictionary<NSString *, NSRelationshipDescription *> *)mcd_toManyRelationshipsByName{
    NSArray *toManyRelationships = self.mcd_toManyRelationships;
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}

- (NSDictionary<NSString *, NSRelationshipDescription *> *)mcd_toOneRelationshipsByName{
    NSArray *toOneRelationships = self.mcd_toOneRelationships;
    return [NSDictionary dictionaryWithObjects:toOneRelationships forKeys:[toOneRelationships valueForKey:@"name"]];
}

- (NSArray<NSRelationshipDescription *> *)mcd_relationshipsWithManagedObjectClass:(Class)managedObjectClass{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"managedObjectClass = %@", managedObjectClass]];
}

- (NSArray *)mcd_toManyRelationships{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = YES"]];
}

- (NSArray *)mcd_toOneRelationships{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = NO"]];
}

- (NSArray *)mcd_transientProperties{
    return [self.properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isTransient = true"]];
}

- (NSString *)mcd_propertyNameForToManyRelation{
    return [[self.name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[self.name substringToIndex:1].lowercaseString] stringByAppendingString:@"s"];
}

@end
