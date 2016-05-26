//
//  MHDataDefines.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <Foundation/Foundation.h>

#ifndef MHDATA_EXTERN
    #ifdef __cplusplus
        #define MHDATA_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MHDATA_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif

// Tweak class clash safety
#ifndef MHDATA_ADD_PREFIX
    #ifdef MHDATA_PREFIX_TO_ADD
        #define __MHDATA_PASTER(a, b) a ## b
        #define __MHDATA_EVALUATOR(a, b) __MHDATA_PASTER(a, b)
        #define MHDATA_ADD_PREFIX(name) __MHDATA_EVALUATOR(MHDATA_PREFIX_TO_ADD, name)
    #else
        #define MHDATA_ADD_PREFIX(name) name
    #endif
#endif

NS_ASSUME_NONNULL_BEGIN

MHDATA_EXTERN NSString * const MHDataErrorDomain;

NS_ASSUME_NONNULL_END