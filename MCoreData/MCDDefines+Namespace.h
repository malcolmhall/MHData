//
//  MCDDefines+Namespace.h
//  MCoreData
//
//  Generated using MHNamespaceGenerator on 19/09/2017
//

#if !defined(__MCDATA_NAMESPACE_APPLY) && defined(MCDATA_NAMESPACE) && defined(MCDATA_NAMESPACE_LOWER)
    #define __MCDATA_NAMESPACE_REWRITE(ns, s) ns ## _ ## s
    #define __MCDATA_NAMESPACE_BRIDGE(ns, s) __MCDATA_NAMESPACE_REWRITE(ns, s)
    #define __MCDATA_NAMESPACE_APPLY(s) __MCDATA_NAMESPACE_BRIDGE(MCDATA_NAMESPACE, s)
	#define __MCDATA_NAMESPACE_APPLY_LOWER(s) __MCDATA_NAMESPACE_BRIDGE(MCDATA_NAMESPACE_LOWER, s)
// Classes
    #define MCDFetchedResultsViewController __MCDATA_NAMESPACE_APPLY(MCDFetchedResultsViewController)
    #define MCDPersistentContainer __MCDATA_NAMESPACE_APPLY(MCDPersistentContainer)
    #define MCDPersistentStoreBridge __MCDATA_NAMESPACE_APPLY(MCDPersistentStoreBridge)
    #define MCDPersistentStoreDescription __MCDATA_NAMESPACE_APPLY(MCDPersistentStoreDescription)
    #define MCDSaveContextOperation __MCDATA_NAMESPACE_APPLY(MCDSaveContextOperation)
    #define MCDStackManager __MCDATA_NAMESPACE_APPLY(MCDStackManager)
// Categories
    #define MCD __MCDATA_NAMESPACE_APPLY(MCD)
    #define mcd_addPersistentStoreWithDescription __MCDATA_NAMESPACE_APPLY_LOWER(mcd_addPersistentStoreWithDescription)
    #define mcd_addStoreWithURL __MCDATA_NAMESPACE_APPLY_LOWER(mcd_addStoreWithURL)
    #define mcd_applicationSupportDirectoryWithError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_applicationSupportDirectoryWithError)
    #define mcd_automaticallyMergesChangesFromParent __MCDATA_NAMESPACE_APPLY_LOWER(mcd_automaticallyMergesChangesFromParent)
    #define mcd_constraintConflictsByConstraint __MCDATA_NAMESPACE_APPLY_LOWER(mcd_constraintConflictsByConstraint)
    #define mcd_coordinatorWithManagedObjectModel __MCDATA_NAMESPACE_APPLY_LOWER(mcd_coordinatorWithManagedObjectModel)
    #define mcd_createChildContext __MCDATA_NAMESPACE_APPLY_LOWER(mcd_createChildContext)
    #define mcd_defaultContext __MCDATA_NAMESPACE_APPLY_LOWER(mcd_defaultContext)
    #define mcd_defaultContextWithError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_defaultContextWithError)
    #define mcd_defaultCoordinatorWithError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_defaultCoordinatorWithError)
    #define mcd_defaultModel __MCDATA_NAMESPACE_APPLY_LOWER(mcd_defaultModel)
    #define mcd_defaultStoreFilename __MCDATA_NAMESPACE_APPLY_LOWER(mcd_defaultStoreFilename)
    #define mcd_defaultStoreURLWithError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_defaultStoreURLWithError)
    #define mcd_entityNamed __MCDATA_NAMESPACE_APPLY_LOWER(mcd_entityNamed)
    #define mcd_existingObjectWithEntityName __MCDATA_NAMESPACE_APPLY_LOWER(mcd_existingObjectWithEntityName)
    #define mcd_fetchObjectsWithEntityName __MCDATA_NAMESPACE_APPLY_LOWER(mcd_fetchObjectsWithEntityName)
    #define mcd_fetchOrInsertObjectWithEntityName __MCDATA_NAMESPACE_APPLY_LOWER(mcd_fetchOrInsertObjectWithEntityName)
    #define mcd_fetchValueForAggregateFunction __MCDATA_NAMESPACE_APPLY_LOWER(mcd_fetchValueForAggregateFunction)
    #define mcd_initWithContext __MCDATA_NAMESPACE_APPLY_LOWER(mcd_initWithContext)
    #define mcd_isConstraintMergeError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_isConstraintMergeError)
    #define mcd_isValidation __MCDATA_NAMESPACE_APPLY_LOWER(mcd_isValidation)
    #define mcd_modelNamed __MCDATA_NAMESPACE_APPLY_LOWER(mcd_modelNamed)
    #define mcd_newBackgroundContextWithError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_newBackgroundContextWithError)
    #define mcd_operationPerformingBlockAndWait __MCDATA_NAMESPACE_APPLY_LOWER(mcd_operationPerformingBlockAndWait)
    #define mcd_predicateWithDictionary __MCDATA_NAMESPACE_APPLY_LOWER(mcd_predicateWithDictionary)
    #define mcd_propertyNameForToManyRelation __MCDATA_NAMESPACE_APPLY_LOWER(mcd_propertyNameForToManyRelation)
    #define mcd_readableDescription __MCDATA_NAMESPACE_APPLY_LOWER(mcd_readableDescription)
    #define mcd_relationshipsWithManagedObjectClass __MCDATA_NAMESPACE_APPLY_LOWER(mcd_relationshipsWithManagedObjectClass)
    #define mcd_saveRollbackOnError __MCDATA_NAMESPACE_APPLY_LOWER(mcd_saveRollbackOnError)
    #define mcd_setAutomaticallyMergesChangesFromParent __MCDATA_NAMESPACE_APPLY_LOWER(mcd_setAutomaticallyMergesChangesFromParent)
    #define mcd_toManyRelationships __MCDATA_NAMESPACE_APPLY_LOWER(mcd_toManyRelationships)
    #define mcd_toManyRelationshipsByName __MCDATA_NAMESPACE_APPLY_LOWER(mcd_toManyRelationshipsByName)
    #define mcd_toOneRelationships __MCDATA_NAMESPACE_APPLY_LOWER(mcd_toOneRelationships)
    #define mcd_toOneRelationshipsByName __MCDATA_NAMESPACE_APPLY_LOWER(mcd_toOneRelationshipsByName)
    #define mcd_transientProperties __MCDATA_NAMESPACE_APPLY_LOWER(mcd_transientProperties)
    #define mcd_validationDescriptionsByEntityName __MCDATA_NAMESPACE_APPLY_LOWER(mcd_validationDescriptionsByEntityName)
// Externs
    #define MCDContextKey __MCDATA_NAMESPACE_APPLY(MCDContextKey)
    #define MCDPersistentStoreBridgeWillExecuteRequestNotification __MCDATA_NAMESPACE_APPLY(MCDPersistentStoreBridgeWillExecuteRequestNotification)
    #define MCDRequestKey __MCDATA_NAMESPACE_APPLY(MCDRequestKey)
    #define MCoreDataErrorDomain __MCDATA_NAMESPACE_APPLY(MCoreDataErrorDomain)
#endif
