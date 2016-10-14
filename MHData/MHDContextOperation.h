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

@protocol MHDContextOperationProtocol <NSObject>

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext;

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

@property (nonatomic, copy, nullable) void (^contextCompletionBlock)(NSError * __nullable operationError);

@end

@interface MHDContextOperation : NSOperation<MHDContextOperationProtocol>

// see protocol above for init etc.

- (void)performAsyncOperation;

- (void)finishWithError:(nullable NSError *)error NS_REQUIRES_SUPER;

- (void)addOperation:(NSOperation *)operation;

- (BOOL)asyncOperationShouldRun:(NSError **)error NS_REQUIRES_SUPER;

@end

@interface MHDBackgroundContextOperation : MHDContextOperation

// will be set after asyncOperationShouldRun is called.
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

@property (nonatomic, assign) BOOL mergeChanges;

@end

NS_ASSUME_NONNULL_END