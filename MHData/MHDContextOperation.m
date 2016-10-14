//
//  MHDContextOperation.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDContextOperation.h"
#import "MHDContextOperationInternal.h"

// We use the class cluster technique to hide the real implementation that is a subclass of an internal-only class.
@implementation MHDContextOperation

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    return (id)[[MHDContextOperationInternal alloc] init];
}
#pragma clang diagnostic pop

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    return (id)[[MHDContextOperationInternal alloc] initWithMainContext:mainContext];
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

- (NSManagedObjectContext *)mainContext{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

- (void)setMainContext:(NSManagedObjectContext *)mainContext{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

- (void (^)(NSError * __nullable operationError))contextCompletionBlock {
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

- (void)setContextCompletionBlock:(void (^)(NSError * __nullable))contextCompletionBlock{
    @throw [NSException exceptionWithName:NSObjectInaccessibleException reason:nil userInfo:nil];
}

@end

@implementation MHDBackgroundContextOperation

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers"
- (instancetype)init
{
    return (id)[[MHDBackgroundContextOperationInternal alloc] init];
}
#pragma clang diagnostic pop

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    return (id)[[MHDBackgroundContextOperationInternal alloc] initWithMainContext:mainContext];
}

@end