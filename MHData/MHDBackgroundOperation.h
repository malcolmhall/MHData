//
//  MHDBackgroundOperation.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 08/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>
#import <MHData/MHDOperation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHDBackgroundOperation : MHDOperation

// will be set after asyncOperationShouldRun is called.
@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

@property (nonatomic, assign) BOOL mergeChanges;

@end

NS_ASSUME_NONNULL_END