//
//  MHPersistentStoreBridge.h
//  MHData
//
//  Created by Malcolm Hall on 16/07/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHData/MHDataDefines.h>

NS_ASSUME_NONNULL_BEGIN

// when adding to a persistent store, declare the destination store type using the NSStoreTypeKey in the options dictionary.

extern NSString * const MHPersistentStoreBridgeWillExecuteRequestNotification;
extern NSString * const MHRequestKey;
extern NSString * const MHContextKey;

@interface MHDATA_ADD_PREFIX(MHPersistentStoreBridge) : NSIncrementalStore

+(NSString*)type;

@end

NS_ASSUME_NONNULL_END