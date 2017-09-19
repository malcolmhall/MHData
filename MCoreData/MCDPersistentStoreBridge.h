//
//  MCDPersistentStoreBridge.h
//  MCoreData
//
//  Created by Malcolm Hall on 16/07/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

// when adding to a persistent store, declare the destination store type using the NSStoreTypeKey in the options dictionary.

extern NSString * const MCDPersistentStoreBridgeWillExecuteRequestNotification;
extern NSString * const MCDRequestKey;
extern NSString * const MCDContextKey;

@interface MCDPersistentStoreBridge : NSIncrementalStore

+(NSString*)type;

@end

NS_ASSUME_NONNULL_END
