//
//  NSEntityDescription+MH.m
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <MHData/NSEntityDescription+MH.h>

@implementation NSEntityDescription (MH)

-(NSDictionary<NSString *, NSRelationshipDescription *> *)MH_toManyRelationshipsByName{
    NSArray* toManyRelationships = self.MH_toManyRelationships;
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}

-(NSDictionary<NSString *, NSRelationshipDescription *> *)MH_toOneRelationshipsByName{
    NSArray* toOneRelationships = self.MH_toOneRelationships;
    return [NSDictionary dictionaryWithObjects:toOneRelationships forKeys:[toOneRelationships valueForKey:@"name"]];
}

- (NSArray<NSRelationshipDescription *> *)MH_relationshipsWithManagedObjectClass:(Class)managedObjectClass{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"managedObjectClass = %@", managedObjectClass]];
}

-(NSArray*)MH_toManyRelationships{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = YES"]];
}

-(NSArray*)MH_toOneRelationships{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = NO"]];
}

-(NSArray*)MH_transientProperties{
    return [self.properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isTransient = true"]];
}

-(NSString*)MH_propertyNameForToManyRelation{
    return [[self.name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[self.name substringToIndex:1].lowercaseString] stringByAppendingString:@"s"];
}

@end
