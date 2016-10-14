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

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext;

@end

@interface MHDContextOperation : NSOperation<MHDContextOperationProtocol>

- (BOOL)asyncOperationShouldRun:(NSError **)error NS_REQUIRES_SUPER;

- (void)performAsyncOperation;

- (void)finishWithError:(NSError * __nullable)error NS_REQUIRES_SUPER;

- (void)addOperation:(NSOperation *)operation;

@property (nonatomic, copy, nullable) void (^operationCompletionBlock)(NSError * __nullable operationError);

@end

@interface MHDBackgroundContextOperation : MHDContextOperation

// will be set after asyncOperationShouldRun is called.
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

@property (nonatomic, assign) BOOL mergeChanges;

@end

NS_ASSUME_NONNULL_END