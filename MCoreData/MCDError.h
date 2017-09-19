//
//  MCDError.h
//  MCoreData
//
//  Created by Malcolm Hall on 09/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

MCDATA_EXTERN NSString * const MCoreDataErrorDomain;

typedef NS_ENUM(NSInteger, MCDErrorCode) {
    MCDErrorUnknown                = 1,  /* Unknown or generic error */
    MCDErrorInvalidArguments       = 2,  /* Things needed were not set */
};

NS_ASSUME_NONNULL_END

