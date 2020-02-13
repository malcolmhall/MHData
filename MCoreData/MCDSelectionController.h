//
//  MCDSelectionController.h
//  MCoreData
//
//  Created by Malcolm Hall on 13/02/2020.
//  Copyright © 2020 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MCDSelectionControllerDelegate;


@interface MCDSelectionController<ResultType:id<NSFetchRequestResult>> : NSObject <NSFetchedResultsControllerDelegate>

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController<ResultType> *)frc;

@property (strong, nonatomic, readonly) NSFetchedResultsController<ResultType> *fetchedResultsController;

@property (strong, nonatomic) ResultType selectedObject;

@property (weak, nonatomic) id<MCDSelectionControllerDelegate> delegate;

- (BOOL)canSelectNext;
- (IBAction)selectNext:(id)sender;

- (BOOL)canSelectPrevious;
- (IBAction)selectPrevious:(id)sender;


@end

@protocol MCDSelectionControllerDelegate <NSObject>

- (void)selectionController:(MCDSelectionController *)selectionController didSelectObject:(id)object;

@end

NS_ASSUME_NONNULL_END
