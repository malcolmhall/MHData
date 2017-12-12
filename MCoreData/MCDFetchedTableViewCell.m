//
//  MCDFetchedTableViewCell.m
//  MCoreData
//
//  Created by Malcolm Hall on 12/10/2017.
//  Copyright © 2017 Malcolm Hall. All rights reserved.
//

#import "MCDFetchedTableViewCell.h"

static void * const kUpdateViewsContext = (void *)&kUpdateViewsContext;

@interface MCDFetchedTableViewCell()

@property (nonatomic) BOOL needsToUpdateViews;

@end

@implementation MCDFetchedTableViewCell

-(void)setFetchedObject:(NSManagedObject *)fetchedObject{
    if(_fetchedObject == fetchedObject){
        return;
    }
    else if(_fetchedObject){
        [self stopObservingCurrentObject];
    }
    _fetchedObject = fetchedObject;
    if(fetchedObject){
        [self startObservingCurrentObject];
        [self updateViewsForCurrentObjectIfNecessary];
    }
}

- (void)startObservingCurrentObject{
    for(NSString *key in self.objectKeyPathsForViews){
        [self.fetchedObject addObserver:self forKeyPath:key options:0 context:kUpdateViewsContext];
    }
}

- (void)stopObservingCurrentObject{
    for(NSString *key in self.objectKeyPathsForViews){
        [self.fetchedObject removeObserver:self forKeyPath:key context:kUpdateViewsContext];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    if(context != kUpdateViewsContext){
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    [self updateViewsForCurrentObjectIfNecessary];
}

- (void)updateViewsForCurrentObjectIfNecessary{
    if(self.window){
        [self updateViewsForCurrentObject];
    }else{
        self.needsToUpdateViews = YES;
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.fetchedObject = nil;
    self.needsToUpdateViews = YES;
}

- (void)updateViewsForCurrentObject{
    self.needsToUpdateViews = NO;
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    if(newWindow && self.needsToUpdateViews){
        [self updateViewsForCurrentObject];
    }
}

- (void)dealloc
{
    self.fetchedObject = nil;
}

@end
