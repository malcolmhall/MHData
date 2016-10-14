//
//  MHDOperation.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDOperation.h"
#import "MHDOperationInternal.h"

@implementation MHDOperation

- (instancetype)init
{
    return (id)[[MHDOperationInternal alloc] init];
}

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    return (id)[[MHDOperationInternal alloc] initWithMainContext:mainContext];
}

- (BOOL)asyncOperationShouldRun:(NSError **)error{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

-(void)performAsyncOperation{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

- (void)finishWithError:(NSError * __nullable)error{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

- (void)addOperation:(NSOperation *)operation{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];    
}

@end

@implementation MHDBackgroundOperation

- (instancetype)init
{
    return (id)[[MHDBackgroundOperationInternal alloc] init];
}

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    return (id)[[MHDBackgroundOperationInternal alloc] initWithMainContext:mainContext];
}

@end