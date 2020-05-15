//
//  MCDFetchedResultsController.h
//  MCoreData
//
//  Created by Malcolm Hall on 15/02/2020.
//  Copyright © 2020 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCDFetchedResultsController : NSFetchedResultsController <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) id<NSFetchedResultsControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
