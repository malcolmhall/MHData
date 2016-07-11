//
//
//  MHDNamespaceDefines.h
//  MHData
//
//  Auto-generated using script created by Malcolm Hall on 11/07/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#if !defined(__MHDATA_NS_SYMBOL) && defined(MHDATA_NAMESPACE)
    #define __MHDATA_NS_REWRITE(ns, symbol) ns ## _ ## symbol
    #define __MHDATA_NS_BRIDGE(ns, symbol) __MHDATA_NS_REWRITE(ns, symbol)
    #define __MHDATA_NS_SYMBOL(symbol) __MHDATA_NS_BRIDGE(MHDATA_NAMESPACE, symbol)
// Classes
    #define MHDFetchedResultsController __MHDATA_NS_SYMBOL(MHDFetchedResultsController)
    #define MHDFetchedResultsViewController __MHDATA_NS_SYMBOL(MHDFetchedResultsViewController)
    #define MHDPersistentContainer __MHDATA_NS_SYMBOL(MHDPersistentContainer)
    #define MHDPersistentStoreBridge __MHDATA_NS_SYMBOL(MHDPersistentStoreBridge)
    #define MHDPersistentStoreDescription __MHDATA_NS_SYMBOL(MHDPersistentStoreDescription)
    #define MHDStackManager __MHDATA_NS_SYMBOL(MHDStackManager)
// Categories
    #define propertyNameForToManyRelation __MHDATA_NS_SYMBOL(propertyNameForToManyRelation)
    #define relationshipsWithManagedObjectClass __MHDATA_NS_SYMBOL(relationshipsWithManagedObjectClass)
    #define toManyRelationshipsByName __MHDATA_NS_SYMBOL(toManyRelationshipsByName)
    #define toManyRelationships __MHDATA_NS_SYMBOL(toManyRelationships)
    #define toOneRelationshipsByName __MHDATA_NS_SYMBOL(toOneRelationshipsByName)
    #define toOneRelationships __MHDATA_NS_SYMBOL(toOneRelationships)
    #define transientProperties __MHDATA_NS_SYMBOL(transientProperties)
    #define automaticallyMergeChangesFromContextDidSaveNotification __MHDATA_NS_SYMBOL(automaticallyMergeChangesFromContextDidSaveNotification)
    #define automaticallyMergesChangesFromParent __MHDATA_NS_SYMBOL(automaticallyMergesChangesFromParent)
    #define createChildContext __MHDATA_NS_SYMBOL(createChildContext)
    #define createPrivateQueueContextWithError __MHDATA_NS_SYMBOL(createPrivateQueueContextWithError)
    #define entityDescriptionForName __MHDATA_NS_SYMBOL(entityDescriptionForName)
    #define fetchObjectWithEntityName __MHDATA_NS_SYMBOL(fetchObjectWithEntityName)
    #define fetchObjectWithEntityName __MHDATA_NS_SYMBOL(fetchObjectWithEntityName)
    #define fetchObjectsWithEntityName __MHDATA_NS_SYMBOL(fetchObjectsWithEntityName)
    #define fetchOrInsertObjectWithEntityName __MHDATA_NS_SYMBOL(fetchOrInsertObjectWithEntityName)
    #define fetchValueForAggregateFunction __MHDATA_NS_SYMBOL(fetchValueForAggregateFunction)
    #define insertNewObjectForEntityName __MHDATA_NS_SYMBOL(insertNewObjectForEntityName)
    #define save __MHDATA_NS_SYMBOL(save)
    #define entityNamed __MHDATA_NS_SYMBOL(entityNamed)
    #define addPersistentStoreWithDescription __MHDATA_NS_SYMBOL(addPersistentStoreWithDescription)
    #define addStoreWithURL __MHDATA_NS_SYMBOL(addStoreWithURL)
// Externs
    #define MHDataVersionString __MHDATA_NS_SYMBOL(MHDataVersionString)
    #define MHDataVersionNumber __MHDATA_NS_SYMBOL(MHDataVersionNumber)
    #define MHDPersistentStoreBridgeWillExecuteRequestNotification __MHDATA_NS_SYMBOL(MHDPersistentStoreBridgeWillExecuteRequestNotification)
    #define MHDRequestKey __MHDATA_NS_SYMBOL(MHDRequestKey)
    #define MHDContextKey __MHDATA_NS_SYMBOL(MHDContextKey)
    #define MHDataErrorDomain __MHDATA_NS_SYMBOL(MHDataErrorDomain)
    #define MHDataVersionString __MHDATA_NS_SYMBOL(MHDataVersionString)
    #define MHDataVersionNumber __MHDATA_NS_SYMBOL(MHDataVersionNumber)
    #define MHDPersistentStoreBridgeWillExecuteRequestNotification __MHDATA_NS_SYMBOL(MHDPersistentStoreBridgeWillExecuteRequestNotification)
    #define MHDRequestKey __MHDATA_NS_SYMBOL(MHDRequestKey)
    #define MHDContextKey __MHDATA_NS_SYMBOL(MHDContextKey)
    #define MHDataErrorDomain __MHDATA_NS_SYMBOL(MHDataErrorDomain)
#endif
