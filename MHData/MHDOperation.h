//
//  MHDOperation.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHFoundation/MHFoundation.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHDOperation : MHFSerialQueueOperation

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext;

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

- (BOOL)asyncOperationShouldRun:(NSError**)error NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END