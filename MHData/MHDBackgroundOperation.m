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
