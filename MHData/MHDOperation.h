//
//  MHDOperation.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#ifdef MHDATA_TARGET
#import <MHFoundation/MHFoundation.h>
#endif
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef MHDATA_TARGET
@interface MHDOperation : MHFSerialQueueOperation
#else
@interface MHDOperation : NSOperation
#endif

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext;

- (BOOL)asyncOperationShouldRun:(NSError **)error NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END