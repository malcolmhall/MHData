//
//  Venue+CoreDataClass.m
//  MCDDemo
//
//  Created by Malcolm Hall on 09/08/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//
//

#import "Venue.h"
#import "Event.h"

@implementation Venue

- (NSString *)titleForTableViewCell{
    return self.timestamp.description;
}

+ (NSSet *)keyPathsForValuesAffectingTitleForTableViewCell{
    return [NSSet setWithObject:@"timestamp"];
}

- (NSString *)subtitleForTableViewCell{
    return [NSString stringWithFormat:@"%ld", self.events.count];
}

+ (NSSet *)keyPathsForValuesAffectingSubtitleForTableViewCell{
    return [NSSet setWithObject:@"events.@count"];
}

- (BOOL)containsObject:(NSManagedObject *)object{
    if(![object isKindOfClass:Event.class]){
        return NO;
    }
    return [self.events containsObject:(Event *)object];
}

@end
