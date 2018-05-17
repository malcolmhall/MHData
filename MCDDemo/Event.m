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

- (nonnull NSArray<NSString *> *)keysForTableViewCell {
    return @[@"timestamp"];
}

- (NSString *)titleForTableViewCell{
    return self.timestamp.description;
}

@end
