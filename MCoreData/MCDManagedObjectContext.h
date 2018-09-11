//
//  MCDManagedObjectContext.h
//  MCoreData
//
//  Created by Malcolm Hall on 06/07/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@class MCDPersistentContainer;

@protocol MCDManagedObjectContext <NSObject>
@end

@interface MCDManagedObjectContext : NSManagedObjectContext <MCDManagedObjectContext>

- (instancetype)initWithConcurrencyType:(NSManagedObjectContextConcurrencyType)ct NS_UNAVAILABLE;

- (instancetype)initWithConcurrencyType:(NSManagedObjectContextConcurrencyType)ct persistentContainer:(MCDPersistentContainer *)persistentContainer NS_DESIGNATED_INITIALIZER;

@property (weak, nonatomic, readonly) MCDPersistentContainer *persistentContainer;

@end

NS_ASSUME_NONNULL_END
