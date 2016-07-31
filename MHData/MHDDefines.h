//
//  MHDDefines.h
//  MHData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#import <MHData/MHDDefines+Namespace.h>

#ifndef MHDATA_EXTERN
    #ifdef __cplusplus
        #define MHDATA_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MHDATA_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif