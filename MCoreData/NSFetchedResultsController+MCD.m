//
//  NSFetchedResultsController+MCD.m
//  MCoreData
//
//  Created by Malcolm Hall on 07/12/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "NSFetchedResultsController+MCD.h"
#import <UIKit/UIKit.h>

@implementation NSFetchedResultsController (MCD)

- (BOOL)mcd_isValidIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >= 0 && indexPath.section < self.sections.count){
        id <NSFetchedResultsSectionInfo> sectionInfo = self.sections[indexPath.section];
        if(indexPath.row >= 0 && indexPath.row < sectionInfo.numberOfObjects){
            return YES;
        }
    }
    return NO;
}

- (NSIndexPath *)mcd_indexPathNearIndexPath:(NSIndexPath *)indexPath{
    // NSAssert(!self.tableView.isEditing, @"Cannot select while editing");
    NSUInteger count = self.sections[indexPath.section].numberOfObjects;// [self numberOfRowsInSection:indexPath.section] ;//self.fetchedResultsController.fetchedObjects.count;
    //id item;
    NSIndexPath *newIndexPath;
    if(count){
        NSUInteger row = count - 1;
        if(indexPath.row < row){
            row = indexPath.row;
        }
        newIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
    }
    return newIndexPath;
}

@end
