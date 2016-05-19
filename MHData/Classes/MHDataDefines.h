//
//  MHDataDefines.h
//  Pods
//
//  Created by Malcolm Hall on 19/05/2016.
//
//

#ifndef MHDataDefines_h
#define MHDataDefines_h

// Tweak Safety
#ifdef MHDATA_PREFIX_TO_ADD
    #define __MHDATA_PASTER(a, b) a ## b
    #define __MHDATA_EVALUATOR(a, b) __MHDATA_PASTER(a, b)
    #define MHDATA_ADD_PREFIX(name) __MHDATA_EVALUATOR(MHDATA_PREFIX_TO_ADD, name)
#else
    #define MHDATA_ADD_PREFIX(name) name
#endif

#endif /* MHDataDefines_h */