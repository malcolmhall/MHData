//
//  MCLManagedObject.h
//  MCoreLocation
//
//  Created by Malcolm Hall on 22/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDLocation : NSManagedObject

@property (nonatomic, strong) CLLocation *location; // transient

@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;
@property (nonatomic, assign, readonly) double altitude;
@property (nonatomic, assign, readonly) double horizontalAccuracy;
// KVO notifications are sent whenever the location changes, thus supports moving a map annotation.
@property (nonatomic, assign, readonly) CLLocationCoordinate2D coordinate;

@end


NS_ASSUME_NONNULL_END
