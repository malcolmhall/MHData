//
//  MHDOperation.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 11/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "MHDOperation.h"
#import "MHDError.h"
#import "NSError+MHD.h"

@implementation MHDOperation

- (instancetype)initWithMainContext:(NSManagedObjectContext *)mainContext
{
    self = [super init];
    if (self) {
        _mainContext = mainContext;
    }
    return self;
}

- (BOOL)asyncOperationShouldRun:(NSError **)error{
    if(!self.mainContext){
        //[NSException raise:NSInternalInconsistencyException format:@"sync manager must be set on sync operation"];
        *error = [NSError mhf_errorWithDomain:MHDataErrorDomain code:MHDErrorInvalidArguments descriptionFormat:@"a mainContext must be provided for %@", NSStringFromClass(self.class)];
        return NO;
    }
    return YES;
}

@end
