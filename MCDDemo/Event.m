//
//  Event+CoreDataClass.m
//  MCDDemo
//
//  Created by Malcolm Hall on 16/05/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//
//

#import "Event.h"

@implementation Event

- (NSString *)titleForTableViewCell{
    return self.timestamp.description;
}

+ (NSSet *)keyPathsForValuesAffectingTitleForTableViewCell{
    return [NSSet setWithObject:@"timestamp"];
}

- (NSString *)subtitleForTableViewCell{
    return [NSString stringWithFormat:@"%ld", self.attendees.count];
}

+ (NSSet *)keyPathsForValuesAffectingSubtitleForTableViewCell{
    return [NSSet setWithObject:@"attendees.@count"];
}

@end
