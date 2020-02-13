//
//  MCDSelectionController.m
//  MCoreData
//
//  Created by Malcolm Hall on 13/02/2020.
//  Copyright © 2020 Malcolm Hall. All rights reserved.
//

#import "MCDSelectionController.h"

@implementation MCDSelectionController

- (instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)frc
{
    self = [super init];
    if (self) {
        _fetchedResultsController = frc;
        frc.delegate = self;
        [frc performFetch:nil];
    }
    return self;
}

- (BOOL)canSelectNext{
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    return [fetchedObjects indexOfObject:self.selectedObject] < fetchedObjects.count - 1;
}

- (IBAction)selectNext:(id)sender{
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    NSUInteger index = [fetchedObjects indexOfObject:self.selectedObject] + 1;
    self.selectedObject = fetchedObjects[index];
}

- (BOOL)canSelectPrevious{
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    return [fetchedObjects indexOfObject:self.selectedObject] > 0;
}

- (IBAction)selectPrevious:(id)sender{
    NSArray *fetchedObjects = self.fetchedResultsController.fetchedObjects;
    NSUInteger index = [fetchedObjects indexOfObject:self.selectedObject] - 1;
    self.selectedObject = fetchedObjects[index];
}

- (void)setSelectedObject:(id<NSFetchRequestResult>)selectedObject{
    if(selectedObject == _selectedObject){
        return;
    }
    _selectedObject = selectedObject;
    [self.delegate selectionController:self didSelectObject:selectedObject];
}

@end
