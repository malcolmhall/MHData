//
//  MCDFetchedTableViewCell.m
//  MCoreData
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MCDResultTableViewCell.h"

static void * const kUpdateViewsContext = (void *)&kUpdateViewsContext;

@interface MCDResultTableViewCell()

@property (nonatomic) BOOL needsToUpdateViews;

@end

@implementation MCDResultTableViewCell

-(void)setResultObject:(NSManagedObject *)resultObject{
    if(_resultObject == resultObject){
        return;
    }
    else if(_resultObject){
        [self stopObservingCurrentResultObject];
    }
    _resultObject = resultObject;
    if(resultObject){
        [self startObservingCurrentResultObject];
        [self updateViewsForCurrentResultObjectIfNecessary];
    }
}

- (void)startObservingCurrentResultObject{
    for(NSString *key in self.resultObjectKeyPathsForViews){
        [self.resultObject addObserver:self forKeyPath:key options:0 context:kUpdateViewsContext];
    }
}

- (void)stopObservingCurrentResultObject{
    for(NSString *key in self.resultObjectKeyPathsForViews){
        [self.resultObject removeObserver:self forKeyPath:key context:kUpdateViewsContext];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    if(context != kUpdateViewsContext){
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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
