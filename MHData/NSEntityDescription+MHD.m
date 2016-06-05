//
//  NSEntityDescription+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <MHData/NSEntityDescription+MHD.h>

@implementation NSEntityDescription (MHD)

-(NSDictionary<NSString *, NSRelationshipDescription *> *)mhd_toManyRelationshipsByName{
    NSArray* toManyRelationships = self.mhd_toManyRelationships;
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}

-(NSDictionary<NSString *, NSRelationshipDescription *> *)mhd_toOneRelationshipsByName{
    NSArray* toOneRelationships = self.mhd_toOneRelationships;
    return [NSDictionary dictionaryWithObjects:toOneRelationships forKeys:[toOneRelationships valueForKey:@"name"]];
}

- (NSArray<NSRelationshipDescription *> *)mhd_relationshipsWithManagedObjectClass:(Class)managedObjectClass{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"managedObjectClass = %@", managedObjectClass]];
}

-(NSArray*)mhd_toManyRelationships{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = YES"]];
}

-(NSArray*)mhd_toOneRelationships{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = NO"]];
}

-(NSArray*)mhd_transientProperties{
    return [self.properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isTransient = true"]];
}

-(NSString*)mhd_propertyNameForToManyRelation{
    return [[self.name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[self.name substringToIndex:1].lowercaseString] stringByAppendingString:@"s"];
}

@end
