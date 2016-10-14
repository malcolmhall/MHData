//
//  MHDContextOperation.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHDContextOperation : NSOperation

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext;

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

@property (nonatomic, copy, nullable) void (^contextCompletionBlock)(NSError * __nullable operationError);

- (void)addOperation:(NSOperation *)operation;

- (void)performAsyncOperation NS_REQUIRES_SUPER;

- (void)finishWithError:(nullable NSError *)error NS_REQUIRES_SUPER;

@end

@interface MHDBackgroundContextOperation : MHDContextOperation

// will be set after asyncOperationShouldRun is called.
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

@property (nonatomic, assign) BOOL mergeChanges;

@end

NS_ASSUME_NONNULL_END