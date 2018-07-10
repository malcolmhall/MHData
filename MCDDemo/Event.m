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

+ (NSSet<NSString *> *)keyPathsForTableViewCell{
    return [NSSet setWithObject:@"timestamp"];
}

@end
