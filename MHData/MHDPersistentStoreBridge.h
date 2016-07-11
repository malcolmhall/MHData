//
//  MHDPersistentStoreBridge.h
//  MHData
//
//  Created by Malcolm Hall on 16/07/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

// when adding to a persistent store, declare the destination store type using the NSStoreTypeKey in the options dictionary.

extern NSString * const MHDPersistentStoreBridgeWillExecuteRequestNotification;
extern NSString * const MHDRequestKey;
extern NSString * const MHDContextKey;

@interface MHDPersistentStoreBridge : NSIncrementalStore

+(NSString*)type;

@end

NS_ASSUME_NONNULL_END