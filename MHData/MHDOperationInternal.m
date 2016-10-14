//
//  MHDOperationInternal.m
//  MHData
//
//  Created by Malcolm Hall on 14/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDOperationInternal.h"
#import "MHDError.h"
#import "NSError+MHD.h"
#import "NSError+MHF.h"
#import "MHDError.h"
#import "NSManagedObjectContext+MHD.h"
#import "MHFAsyncOperation_Private.h"

@implementation MHDOperationInternal

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    self = [super init];
    if (self) {
        _mainContext = mainContext;
    }
    return self;
}

- (BOOL)asyncOperationShouldRun:(NSError **)error{
    if(!self.mainContext){
        //[NSException raise:NSInternalInconsistencyException format:@"sync manager must be set on sync operation"];
        *error = [NSError mhf_errorWithDomain:MHDataErrorDomain code:MHDErrorInvalidArguments descriptionFormat:@"a mainContext must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    return YES;
}

@end


@interface MHDBackgroundOperationInternal()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *backgroundContext;

@end

@implementation MHDBackgroundOperationInternal

-(BOOL)asyncOperationShouldRun:(NSError**)error{
    if(![super asyncOperationShouldRun:error]){
        return NO;
    }
    
    self.backgroundContext = [self.mainContext mhd_newBackgroundContextWithError:error];
    if(!self.backgroundContext){
        return NO;
    }
    else if(self.mergeChanges){
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(backgroundContextDidSaveNotificationHandler:)
                                                     name:NSManagedObjectContextDidSaveNotification
                                                   object:self.backgroundContext
         ];
    }
    
    return YES;
}

- (void)backgroundContextDidSaveNotificationHandler:(NSNotification *)notification {
    [self.mainContext performBlockAndWait:^{
        for (NSManagedObject *updatedObject in notification.userInfo[NSUpdatedObjectsKey]) {
            // perform a fault to fix bug in fetched result controller.
            [self.mainContext existingObjectWithID:updatedObject.objectID error:nil];
        }
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

-(void)performAsyncOperation{
    [super performAsyncOperation]; // starts the queue asyncronously
    
    NSBlockOperation* saveOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self.backgroundContext performBlockAndWait:^{
            NSError* error;
            if(![self.backgroundContext save:&error]){
                [self finishWithError:error];
            }
        }];
    }];
    [self addOperation:saveOperation];
}

-(void)finishOnCallbackQueueWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super finishOnCallbackQueueWithError:error];
}

@end
