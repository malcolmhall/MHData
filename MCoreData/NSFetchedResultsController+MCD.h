//
//  NSFetchedResultsController+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 07/12/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSFetchedResultsController (MCD)

- (BOOL)mcd_isValidIndexPath:(NSIndexPath *)indexPath;

//- (NSIndexPath *)mcd_indexPathNearIndexPath:(NSIndexPath *)indexPath;

- (void)mcd_setDelegateNotifyingParent:(id<NSFetchedResultsControllerDelegate>)delegate;

@property (weak, nonatomic, setter=mcd_setParentFetchedResultsController:) NSFetchedResultsController *mcd_parentFetchedResultsController;

@end

NS_ASSUME_NONNULL_END
