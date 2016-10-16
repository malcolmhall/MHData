//
//  MHDSaveContextOperation.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDSaveContextOperation_Internal.h"
#import "MHDError.h"
#import "NSError+MHD.h"
#import "MHDError.h"
#import "NSManagedObjectContext+MHD.h"

@interface MHDSaveContextOperation()

@end

// We use the class cluster technique to hide the real implementation that is a subclass of an internal-only class.
@implementation MHDSaveContextOperation

- (instancetype)initWithContext:(NSManagedObjectContext *)context
{
    self = [self init];
    if (self) {
        _context = context;
    }
    return self;
}

- (BOOL)asyncOperationShouldRun:(NSError **)error{
    if(!self.context){
        *error = [NSError mhf_errorWithDomain:MHDataErrorDomain code:MHDErrorInvalidArguments descriptionFormat:@"a context must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    return [super asyncOperationShouldRun:error];
}

-(void)performAsyncOperation{
    [super performAsyncOperation]; // starts the queue asyncronously
    
    NSBlockOperation* saveOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self.context performBlockAndWait:^{
            NSError* error;
            if(![self.context save:&error]){
                [self finishWithError:error];
            }
        }];
    }];
    [self addOperation:saveOperation];
}

-(void)finishOnCallbackQueueWithError:(NSError *)error{
    if(self.saveContextCompletionBlock){
        self.saveContextCompletionBlock(error);
    }
    [super finishOnCallbackQueueWithError:error];
}

@end