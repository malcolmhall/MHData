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

/*
//  When developing a tweak #define MHDATA_PREFIX_TO_ADD TweakName for extra class clash safety.
#if !defined(MHDATA_ADD_PREFIX) && defined(MHDATA_PREFIX_TO_ADD)
    #define __MHDATA_PASTE__(a, b) a ## _ ## b
    #define __MHDATA_ADD_PREFIX_IMPL__(a, b) __MHDATA_PASTE__(a, b)
    #define MHDATA_ADD_PREFIX(name) __MHDATA_ADD_PREFIX_IMPL__(MHDATA_PREFIX_TO_ADD, name)

    #define MHDStackManager MHDATA_ADD_PREFIX(MHDStackManager)

    #define MHDFetchedResultsController MHDATA_ADD_PREFIX(MHDFetchedResultsController)

    #define MHDFetchedResultsViewController MHDATA_ADD_PREFIX(MHDFetchedResultsViewController)

    #define MHDPersistentStoreBridge MHDATA_ADD_PREFIX(MHDPersistentStoreBridge)

    #define mhd_defaultContext MHDATA_ADD_PREFIX(mhd_defaultContext)
    #define mhd_defaultContextWithError MHDATA_ADD_PREFIX(mhd_defaultContextWithError)
    #define mhd_createPrivateQueueContextWithError MHDATA_ADD_PREFIX(mhd_defaultContext)
    #define mhd_createChildContext MHDATA_ADD_PREFIX(mhd_createChildContext)
    #define mhd_insertNewObjectForEntityName MHDATA_ADD_PREFIX(mhd_insertNewObjectForEntityName)
    #define mhd_entityDescriptionForName MHDATA_ADD_PREFIX(mhd_entityDescriptionForName)
    #define mhd_fetchObjectsWithEntityName MHDATA_ADD_PREFIX(mhd_fetchObjectsWithEntityName)
    #define mhd_fetchObjectWithEntityName MHDATA_ADD_PREFIX(mhd_fetchObjectWithEntityName)
    #define mhd_fetchOrInsertObjectWithEntityName MHDATA_ADD_PREFIX(mhd_fetchOrInsertObjectWithEntityName)
    #define mhd_save MHDATA_ADD_PREFIX(mhd_save)
    #define mhd_fetchValueForAggregateFunction MHDATA_ADD_PREFIX(mhd_fetchValueForAggregateFunction)
    #define mhd_automaticallyMergesChangesFromParent MHDATA_ADD_PREFIX(mhd_automaticallyMergesChangesFromParent)

    #define mhd_toManyRelationshipsByName MHDATA_ADD_PREFIX(mhd_toManyRelationshipsByName)
    #define mhd_toOneRelationshipsByName MHDATA_ADD_PREFIX(mhd_toOneRelationshipsByName)
    #define mhd_relationshipsWithManagedObjectClass MHDATA_ADD_PREFIX(mhd_relationshipsWithManagedObjectClass)
    #define mhd_toManyRelationships MHDATA_ADD_PREFIX(mhd_toManyRelationships)
    #define mhd_toOneRelationships MHDATA_ADD_PREFIX(mhd_toOneRelationships)
    #define mhd_propertyNameForToManyRelation MHDATA_ADD_PREFIX(mhd_propertyNameForToManyRelation)
    #define mhd_transientProperties MHDATA_ADD_PREFIX(mhd_transientProperties)

    // NSManagedObjectModel
    #define mhd_defaultModel MHDATA_ADD_PREFIX(mhd_defaultModel)
    #define mhd_modelNamed MHDATA_ADD_PREFIX(mhd_modelNamed)
    #define mhd_entityNamed MHDATA_ADD_PREFIX(mhd_entityNamed)

    //NSPersistentStoreCoordinator
    #define mhd_defaultCoordinatorWithError MHDATA_ADD_PREFIX(mhd_defaultCoordinatorWithError)
    #define mhd_coordinatorWithManagedObjectModel MHDATA_ADD_PREFIX(mhd_coordinatorWithManagedObjectModel)
    #define mhd_addStoreWithURL MHDATA_ADD_PREFIX(mhd_addStoreWithURL)
    #define mhd_defaultStoreURLWithError MHDATA_ADD_PREFIX(mhd_defaultStoreURLWithError)
    #define mhd_defaultStoreFilename MHDATA_ADD_PREFIX(mhd_defaultStoreFilename)
    #define mhd_applicationSupportDirectoryWithError MHDATA_ADD_PREFIX(mhd_applicationSupportDirectoryWithError)
    #define mhd_addPersistentStoreWithDescription MHDATA_ADD_PREFIX(mhd_addPersistentStoreWithDescription)
#endif
*/