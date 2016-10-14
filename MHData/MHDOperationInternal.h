//
//  MHDOperationInternal.h
//  MHData
//
//  Created by Malcolm Hall on 14/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHFoundation/MHFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHDOperationInternal : MHFSerialQueueOperation

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext;

- (BOOL)asyncOperationShouldRun:(NSError **)error NS_REQUIRES_SUPER;

@end

@interface MHDBackgroundOperationInternal : MHDOperationInternal

// will be set after asyncOperationShouldRun is called.
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

@property (nonatomic, assign) BOOL mergeChanges;

@end

NS_ASSUME_NONNULL_END