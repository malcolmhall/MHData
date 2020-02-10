//
//  MCDManagedObjectChangeController.h
//  MCoreData
//
//  Created by Malcolm Hall on 11/08/2019.
//  Copyright © 2019 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

typedef NS_ENUM(NSUInteger, MCDManagedObjectChangeType) {
    MCDManagedObjectChangeInsert = 1,
    MCDManagedObjectChangeDelete = 2,
    MCDManagedObjectChangeUpdate = 3
};

NS_ASSUME_NONNULL_BEGIN

@protocol MCDManagedObjectChangeControllerDelegate;

@interface MCDManagedObjectChangeController : NSObject

- (instancetype)initWithManagedObject:(NSManagedObject *)managedObject managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@property (weak, nonatomic) id<MCDManagedObjectChangeControllerDelegate> delegate;

//@property (assign, nonatomic, readonly) BOOL isDeleted;

@end

@protocol MCDManagedObjectChangeControllerDelegate <NSObject>

- (void)controller:(MCDManagedObjectChangeController *)controller didChange:(MCDManagedObjectChangeType)type;

@end

NS_ASSUME_NONNULL_END
