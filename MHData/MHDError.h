//
//  MHDError.h
//  MHData
//
//  Created by Malcolm Hall on 09/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MHData/MHDDefines.h>

NS_ASSUME_NONNULL_BEGIN

MHDATA_EXTERN NSString * const MHDataErrorDomain;

typedef NS_ENUM(NSInteger, MHDErrorCode) {
    MHDErrorUnknown                = 1,  /* Unknown or generic error */
    MHDErrorInvalidArguments       = 2,  /* Things needed were not set */
};

NS_ASSUME_NONNULL_END

