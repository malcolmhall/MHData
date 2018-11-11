//
//  MCDDefines.h
//  MCoreData
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#ifndef MCDATA_EXTERN
    #ifdef __cplusplus
        #define MCDATA_EXTERN   extern "C" __attribute__((visibility ("default")))
    #else
        #define MCDATA_EXTERN   extern __attribute__((visibility ("default")))
    #endif
#endif


