//
//  MCDDefines+Namespace.h
//  MCoreData
//
//  Generated using MHNamespaceGenerator on 29/10/2017
//

#if !defined(__MCOREDATA_NAMESPACE_APPLY) && defined(MCOREDATA_NAMESPACE) && defined(MCOREDATA_NAMESPACE_LOWER)
    #define __MCOREDATA_NAMESPACE_REWRITE(ns, s) ns ## _ ## s
    #define __MCOREDATA_NAMESPACE_BRIDGE(ns, s) __MCOREDATA_NAMESPACE_REWRITE(ns, s)
    #define __MCOREDATA_NAMESPACE_APPLY(s) __MCOREDATA_NAMESPACE_BRIDGE(MCOREDATA_NAMESPACE, s)
	#define __MCOREDATA_NAMESPACE_APPLY_LOWER(s) __MCOREDATA_NAMESPACE_BRIDGE(MCOREDATA_NAMESPACE_LOWER, s)
// Classes
    #define MCDPersistentContainer __MCOREDATA_NAMESPACE_APPLY(MCDPersistentContainer)
    #define MCDPersistentStoreBridge __MCOREDATA_NAMESPACE_APPLY(MCDPersistentStoreBridge)
    #define MCDPersistentStoreDescription __MCOREDATA_NAMESPACE_APPLY(MCDPersistentStoreDescription)
    #define MCDResultTableViewCell __MCOREDATA_NAMESPACE_APPLY(MCDResultTableViewCell)
    #define MCDResultsTableViewController __MCOREDATA_NAMESPACE_APPLY(MCDResultsTableViewController)
    #define MCDStackManager __MCOREDATA_NAMESPACE_APPLY(MCDStackManager)
// Categories
    #define MCD __MCOREDATA_NAMESPACE_APPLY(MCD)
    #define mcd_addPersistentStoreWithDescription __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_addPersistentStoreWithDescription)
    #define mcd_addStoreWithURL __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_addStoreWithURL)
    #define mcd_applicationSupportDirectoryWithError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_applicationSupportDirectoryWithError)
    #define mcd_automaticallyMergesChangesFromParent __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_automaticallyMergesChangesFromParent)
    #define mcd_constraintConflictsByConstraint __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_constraintConflictsByConstraint)
    #define mcd_coordinatorWithManagedObjectModel __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_coordinatorWithManagedObjectModel)
    #define mcd_countOfObjectsMatchingPredicate __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_countOfObjectsMatchingPredicate)
    #define mcd_createChildContext __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_createChildContext)
    #define mcd_defaultContext __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_defaultContext)
    #define mcd_defaultContextWithError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_defaultContextWithError)
    #define mcd_defaultCoordinatorWithError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_defaultCoordinatorWithError)
    #define mcd_defaultModel __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_defaultModel)
    #define mcd_defaultStoreFilename __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_defaultStoreFilename)
    #define mcd_defaultStoreURLWithError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_defaultStoreURLWithError)
    #define mcd_entityNamed __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_entityNamed)
    #define mcd_existingObjectWithEntityName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_existingObjectWithEntityName)
    #define mcd_fetchObjectsWithEntityName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_fetchObjectsWithEntityName)
    #define mcd_fetchOrInsertObjectWithEntityName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_fetchOrInsertObjectWithEntityName)
    #define mcd_fetchValueForAggregateFunction __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_fetchValueForAggregateFunction)
    #define mcd_initWithContext __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_initWithContext)
    #define mcd_isConstraintMergeError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_isConstraintMergeError)
    #define mcd_isValidationError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_isValidationError)
    #define mcd_modelNamed __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_modelNamed)
    #define mcd_newBackgroundContextWithError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_newBackgroundContextWithError)
    #define mcd_objectFromObjectID __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_objectFromObjectID)
    #define mcd_objectIDsFromObjects __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_objectIDsFromObjects)
    #define mcd_objectIDsMatchingPredicate __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_objectIDsMatchingPredicate)
    #define mcd_objectsFromObjectIDs __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_objectsFromObjectIDs)
    #define mcd_objectsMatchingPredicate __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_objectsMatchingPredicate)
    #define mcd_obtainPermanentObjectIDIfNecessary __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_obtainPermanentObjectIDIfNecessary)
    #define mcd_operationPerformingBlockAndWait __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_operationPerformingBlockAndWait)
    #define mcd_permanentObjectID __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_permanentObjectID)
    #define mcd_permanentObjectIDsFromObjects __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_permanentObjectIDsFromObjects)
    #define mcd_postNotificationOnMainThreadAfterSaveWithName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_postNotificationOnMainThreadAfterSaveWithName)
    #define mcd_postNotificationOnMainThreadWithName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_postNotificationOnMainThreadWithName)
    #define mcd_predicateWithDictionary __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_predicateWithDictionary)
    #define mcd_propertyNameForToManyRelation __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_propertyNameForToManyRelation)
    #define mcd_readableDescription __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_readableDescription)
    #define mcd_relationshipsWithManagedObjectClass __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_relationshipsWithManagedObjectClass)
    #define mcd_resultsMatchingPredicate __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_resultsMatchingPredicate)
    #define mcd_save __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_save)
    #define mcd_saveRollbackOnError __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_saveRollbackOnError)
    #define mcd_saveWithLogDescription __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_saveWithLogDescription)
    #define mcd_setAutomaticallyMergesChangesFromParent __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_setAutomaticallyMergesChangesFromParent)
    #define mcd_toManyRelationships __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_toManyRelationships)
    #define mcd_toManyRelationshipsByName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_toManyRelationshipsByName)
    #define mcd_toOneRelationships __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_toOneRelationships)
    #define mcd_toOneRelationshipsByName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_toOneRelationshipsByName)
    #define mcd_transientProperties __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_transientProperties)
    #define mcd_validationDescriptionsByEntityName __MCOREDATA_NAMESPACE_APPLY_LOWER(mcd_validationDescriptionsByEntityName)
// Externs
    #define MCDContextKey __MCOREDATA_NAMESPACE_APPLY(MCDContextKey)
    #define MCDPersistentStoreBridgeWillExecuteRequestNotification __MCOREDATA_NAMESPACE_APPLY(MCDPersistentStoreBridgeWillExecuteRequestNotification)
    #define MCDRequestKey __MCOREDATA_NAMESPACE_APPLY(MCDRequestKey)
    #define MCoreDataErrorDomain __MCOREDATA_NAMESPACE_APPLY(MCoreDataErrorDomain)
#endif
