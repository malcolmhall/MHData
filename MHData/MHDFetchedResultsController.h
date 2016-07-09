//
//  MHDFetchedResultsController.h
//  MHData
//
//  Created by Malcolm Hall on 04/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MHData/MHDataDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHDFetchedResultsController : NSFetchedResultsController

/* An NSComparator block which sorts the objects after filtering and sectioning */
@property (nonatomic, copy) NSComparator postFetchComparator;

//@property (nonatomic, copy) BOOL(^postFetchFilterTest)(id obj, BOOL *stop) ;

@end

NS_ASSUME_NONNULL_END