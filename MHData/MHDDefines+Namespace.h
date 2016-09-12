//
//  MHDDefines+Namespace.h
//  MHData
//
//  Generated using MHNamespaceGenerator on 12/09/2016
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
    #define mhd_addPersistentStoreWithDescription __MHDATA_NS_SYMBOL(mhd_addPersistentStoreWithDescription)
    #define mhd_addStoreWithURL __MHDATA_NS_SYMBOL(mhd_addStoreWithURL)
    #define mhd_applicationSupportDirectoryWithError __MHDATA_NS_SYMBOL(mhd_applicationSupportDirectoryWithError)
    #define mhd_automaticallyMergeChangesFromContextDidSaveNotification __MHDATA_NS_SYMBOL(mhd_automaticallyMergeChangesFromContextDidSaveNotification)
    #define mhd_automaticallyMergesChangesFromParent __MHDATA_NS_SYMBOL(mhd_automaticallyMergesChangesFromParent)
    #define mhd_coordinatorWithManagedObjectModel __MHDATA_NS_SYMBOL(mhd_coordinatorWithManagedObjectModel)
    #define mhd_createChildContext __MHDATA_NS_SYMBOL(mhd_createChildContext)
    #define mhd_createPrivateQueueContextWithError __MHDATA_NS_SYMBOL(mhd_createPrivateQueueContextWithError)
    #define mhd_defaultContext __MHDATA_NS_SYMBOL(mhd_defaultContext)
    #define mhd_defaultContextWithError __MHDATA_NS_SYMBOL(mhd_defaultContextWithError)
    #define mhd_defaultCoordinatorWithError __MHDATA_NS_SYMBOL(mhd_defaultCoordinatorWithError)
    #define mhd_defaultModel __MHDATA_NS_SYMBOL(mhd_defaultModel)
    #define mhd_defaultStoreFilename __MHDATA_NS_SYMBOL(mhd_defaultStoreFilename)
    #define mhd_defaultStoreURLWithError __MHDATA_NS_SYMBOL(mhd_defaultStoreURLWithError)
    #define mhd_entityNamed __MHDATA_NS_SYMBOL(mhd_entityNamed)
    #define mhd_fetchObjectWithEntityName __MHDATA_NS_SYMBOL(mhd_fetchObjectWithEntityName)
    #define mhd_fetchObjectsWithEntityName __MHDATA_NS_SYMBOL(mhd_fetchObjectsWithEntityName)
    #define mhd_fetchOrInsertObjectWithEntityName __MHDATA_NS_SYMBOL(mhd_fetchOrInsertObjectWithEntityName)
    #define mhd_fetchValueForAggregateFunction __MHDATA_NS_SYMBOL(mhd_fetchValueForAggregateFunction)
    #define mhd_initWithContext __MHDATA_NS_SYMBOL(mhd_initWithContext)
    #define mhd_isValidation __MHDATA_NS_SYMBOL(mhd_isValidation)
    #define mhd_localizedDisplayDescription __MHDATA_NS_SYMBOL(mhd_localizedDisplayDescription)
    #define mhd_modelNamed __MHDATA_NS_SYMBOL(mhd_modelNamed)
    #define mhd_propertyNameForToManyRelation __MHDATA_NS_SYMBOL(mhd_propertyNameForToManyRelation)
    #define mhd_relationshipsWithManagedObjectClass __MHDATA_NS_SYMBOL(mhd_relationshipsWithManagedObjectClass)
    #define mhd_save __MHDATA_NS_SYMBOL(mhd_save)
    #define mhd_setAutomaticallyMergesChangesFromParent __MHDATA_NS_SYMBOL(mhd_setAutomaticallyMergesChangesFromParent)
    #define mhd_toManyRelationships __MHDATA_NS_SYMBOL(mhd_toManyRelationships)
    #define mhd_toManyRelationshipsByName __MHDATA_NS_SYMBOL(mhd_toManyRelationshipsByName)
    #define mhd_toOneRelationships __MHDATA_NS_SYMBOL(mhd_toOneRelationships)
    #define mhd_toOneRelationshipsByName __MHDATA_NS_SYMBOL(mhd_toOneRelationshipsByName)
    #define mhd_transientProperties __MHDATA_NS_SYMBOL(mhd_transientProperties)
// Externs
    #define MHDContextKey __MHDATA_NS_SYMBOL(MHDContextKey)
    #define MHDPersistentStoreBridgeWillExecuteRequestNotification __MHDATA_NS_SYMBOL(MHDPersistentStoreBridgeWillExecuteRequestNotification)
    #define MHDRequestKey __MHDATA_NS_SYMBOL(MHDRequestKey)
    #define MHDataErrorDomain __MHDATA_NS_SYMBOL(MHDataErrorDomain)
    #define MHDataVersionNumber __MHDATA_NS_SYMBOL(MHDataVersionNumber)
    #define MHDataVersionString __MHDATA_NS_SYMBOL(MHDataVersionString)
#endif
