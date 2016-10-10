//
//  MHDBackgroundOperation.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 08/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDBackgroundOperation.h"
#import "MHDError.h"
#import "NSManagedObjectContext+MHD.h"

@interface MHDBackgroundOperation()

@property (nonatomic, strong, readwrite) NSManagedObjectContext *backgroundContext;

@end

@implementation MHDBackgroundOperation

-(BOOL)asyncOperationShouldRun:(NSError**)error{
    if(!self.mainContext){
        //[NSException raise:NSInternalInconsistencyException format:@"sync manager must be set on sync operation"];
        *error = [NSError mhf_errorWithDomain:MHDataErrorDomain code:MHDErrorInvalidArguments descriptionFormat:@"a mainContext must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    
    NSManagedObjectContext *backgroundContext = [self.mainContext mhd_createPrivateQueueContextWithError:error];
    if(!backgroundContext){
        return NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(backgroundContextDidSaveNotificationHandler:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:backgroundContext
    ];
    self.backgroundContext = backgroundContext;
    
    return YES;
}

- (void)backgroundContextDidSaveNotificationHandler:(NSNotification *)notification {
    [self.mainContext performBlockAndWait:^{
        for (NSManagedObject *updatedObject in notification.userInfo[NSUpdatedObjectsKey]) {
            // perform a fault to overcome bug
            [self.mainContext existingObjectWithID:updatedObject.objectID error:nil];
        }
        [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
    }];
}

-(void)performAsyncOperation{
    [super performAsyncOperation]; // adds the finished operation.
    
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

- (void)finishWithError:(NSError *)error{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super finishWithError:error];
}

@end
