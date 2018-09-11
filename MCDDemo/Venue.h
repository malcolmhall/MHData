//
//  Venue+CoreDataClass.h
//  MCDDemo
//
//  Created by Malcolm Hall on 09/08/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//
//

#import <MCoreData/MCoreData.h>

@class Event;

NS_ASSUME_NONNULL_BEGIN

@interface Venue : NSManagedObject <MCDTableViewCellObject>

@end

NS_ASSUME_NONNULL_END

#import "Venue+CoreDataProperties.h"
