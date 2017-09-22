//
//  MCDSaveContextOperation.h
//  MCoreData
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDSaveContextOperation : NSOperation

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@property (nonatomic, strong, nullable) NSManagedObjectContext *context;

@property (nonatomic, copy, nullable) void (^saveContextCompletionBlock)(NSError * __nullable operationError);

- (void)addOperation:(NSOperation *)operation;

- (BOOL)asyncOperationShouldRun:(NSError **)error NS_REQUIRES_SUPER;

- (void)performAsyncOperation NS_REQUIRES_SUPER;

- (void)finishWithError:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
