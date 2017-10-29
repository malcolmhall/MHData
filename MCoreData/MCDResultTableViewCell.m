//
//  MCDFetchedTableViewCell.m
//  MCoreData
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MCDResultTableViewCell.h"

static void * const kMCDResultTableViewCellKVOContext = (void *)&kMCDResultTableViewCellKVOContext;

@interface MCDResultTableViewCell()

@property (nonatomic) BOOL needsToUpdateViews;

@end

@implementation MCDResultTableViewCell

-(void)setResultObject:(NSManagedObject *)resultObject{
    if(_resultObject == resultObject){
        return;
    }
    else if(_resultObject){
        [self stopObservingResultObject];
    }
    _resultObject = resultObject;
    if(resultObject){
        [self startObservingResultObject];
        [self updateViewsForCurrentResultObjectIfNecessary];
    }
}

- (void)startObservingResultObject{
    for(NSString *key in self.keyPathsForUpdatingViews){
        [self.resultObject addObserver:self forKeyPath:key options:0 context:kMCDResultTableViewCellKVOContext];
    }
}

- (void)stopObservingResultObject{
    for(NSString *key in self.keyPathsForUpdatingViews){
        [self.resultObject removeObserver:self forKeyPath:key context:kMCDResultTableViewCellKVOContext];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    if(context != kMCDResultTableViewCellKVOContext){
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    else if(![self.keyPathsForUpdatingViews containsObject:keyPath]){
        return;
    }
    [self updateViewsForCurrentResultObjectIfNecessary];
}

- (void)updateViewsForCurrentResultObjectIfNecessary{
    if(self.window){
        [self updateViewsForCurrentResultObject];
    }else{
        self.needsToUpdateViews = YES;
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.needsToUpdateViews = YES;
}

- (void)updateViewsForCurrentResultObject{
    self.needsToUpdateViews = NO;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    if(newWindow && self.needsToUpdateViews){
        [self updateViewsForCurrentResultObject];
    }
}

- (void)dealloc
{
    self.resultObject = nil;
}

@end
