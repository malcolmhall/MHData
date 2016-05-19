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
    NSArray* toManyRelationships = [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = YES"]];
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}

-(NSDictionary<NSString *, NSRelationshipDescription *> *)MH_toOneRelationshipsByName{
    NSArray* toManyRelationships = [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isToMany = NO"]];
    return [NSDictionary dictionaryWithObjects:toManyRelationships forKeys:[toManyRelationships valueForKey:@"name"]];
}

- (NSArray<NSRelationshipDescription *> *)MH_relationshipsWithManagedObjectClass:(Class)managedObjectClass{
    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"managedObjectClass = %@", managedObjectClass]];
}

//-(NSArray*)MH_toManyRelations{
//    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isToMany = true"]];
//}
//
//-(NSSet*)MH_toManyRelationNames{
//    return [NSSet setWithArray:[self.MH_toManyRelations valueForKey:@"name"]];
//}

-(NSArray*)MH_transientProperties{
    return [self.properties filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isTransient = true"]];
}

//-(NSArray*)MH_toOneRelations{
//    return [self.relationshipsByName.allValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.isToMany = false"]];
//}

-(NSString*)MH_propertyNameForToManyRelation{
    return [[self.name stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                               withString:[self.name substringToIndex:1].lowercaseString] stringByAppendingString:@"s"];
}

@end
