//
//  MCDManagedObjectChangeObserver.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
// This class can be used by UI that displays an object by allowing a single method that updates views intially and for any change.

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

@protocol MCDManagedObjectChangeObserverDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface MCDManagedObjectChangeObserver : NSObject

- (instancetype)initWithDelegate:(id<MCDManagedObjectChangeObserverDelegate>)delegate;

@property (weak, nonatomic, readonly) id<MCDManagedObjectChangeObserverDelegate> delegate;
@property (strong, nonatomic) NSArray<NSString *> *keyPaths;
@property (weak, nonatomic) __kindof NSManagedObject *object;

@end

@protocol MCDManagedObjectChangeObserverDelegate <NSObject>

@required
// called when the object or keyPaths property are changed but more importantly when the keyPath of the object value changes to a new value.
- (void)managedObjectChangeObserver:(MCDManagedObjectChangeObserver *)observer didUpdateKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
