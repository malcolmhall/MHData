//
//  MHDContextOperation.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDContextOperation_Private.h"
#import "MHDContextOperationInternal.h"
#import "MHDError.h"
#import "NSError+MHD.h"
#import "NSError+MHF.h"
#import "MHDError.h"
#import "NSManagedObjectContext+MHD.h"
#import "MHFAsyncOperation_Private.h"

@interface MHDContextOperation()

@property (nonatomic, strong) MHDContextOperationInternal *internal;

@end

// We use the class cluster technique to hide the real implementation that is a subclass of an internal-only class.
@implementation MHDContextOperation

- (instancetype)init
{
    self = [super init];
    if (self) {
        _internal = [[MHDContextOperationInternal alloc] init];
    }
    return self;
}

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    self = [self init];
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
    return [self.internal asyncOperationShouldRun:error];
}

-(void)performAsyncOperation{
    [self.internal performAsyncOperation];
}

- (void)finishWithError:(NSError * __nullable)error{
    [self.internal finishWithError:error];
}

- (void)addOperation:(NSOperation *)operation{
    [self.internal addOperation:operation];
}

-(void)finishOnCallbackQueueWithError:(NSError *)error{
    [self.internal finishOnCallbackQueueWithError:error];
}

- (void)performBlockOnCallbackQueue:(dispatch_block_t)block{
    [self.internal performBlockOnCallbackQueue:block];
}

@end

@interface MHDBackgroundContextOperation()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *backgroundContext;

@end

@implementation MHDBackgroundContextOperation

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
    if(self.contextCompletionBlock){
        self.contextCompletionBlock(error);
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super finishOnCallbackQueueWithError:error];
}

@end