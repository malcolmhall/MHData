//
//  MHDBackgroundOperation.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 08/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MHFoundation/MHFoundation.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHDBackgroundOperation : MHFSerialQueueOperation

@property (nonatomic, strong, nullable) NSManagedObjectContext *mainContext;

@property (nonatomic, strong, readonly) NSManagedObjectContext *backgroundContext;

// merges changes from the backgroundContext to the mainContext.
- (void)backgroundContextDidSaveNotificationHandler:(NSNotification *)notification;

@end

NS_ASSUME_NONNULL_END