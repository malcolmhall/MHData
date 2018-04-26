//
//  MCDManagedObjectTableViewCell.m
//  MCoreData
//
//  Created by Malcolm Hall on 27/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDManagedObjectTableViewCell.h"

static void * const kUpdateViewsContext = (void *)&kUpdateViewsContext;

@interface MCDManagedObjectTableViewCell ()
@property (nonatomic) BOOL needsToUpdateViews;
@end

@implementation MCDManagedObjectTableViewCell

- (void)setObject:(NSManagedObject *)object{
    if(_object == object){
        return;
    }
    else if(_object){
        [self removeUpdateViewsObserversForObject:_object];
    }
    _object = object;
    if(object){
        [self addUpdateViewsObserversForObject:object];
    }
    [self updateViewsFromCurrentObjectIfNecessary];
}

- (void)addUpdateViewsObserversForObject:(NSManagedObject *)object{
    for(NSString *keyPath in self.viewedKeys){
        [object addObserver:self forKeyPath:keyPath options:0 context:kUpdateViewsContext];
    }
}

- (void)removeUpdateViewsObserversForObject:(NSManagedObject *)object{
    for(NSString *keyPath in self.viewedKeys){
        [object removeObserver:self forKeyPath:keyPath context:kUpdateViewsContext];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    if(context != kUpdateViewsContext){
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    [self updateViewsFromCurrentObjectIfNecessary];
}

- (void)updateViewsFromCurrentObject{
    self.needsToUpdateViews = NO;
}

- (void)updateViewsFromCurrentObjectIfNecessary{
    if(self.window){
        [self updateViewsFromCurrentObject];
    }else{
        self.needsToUpdateViews = YES;
    }
}

- (void)willMoveToWindow:(UIWindow *)window{
    if(window && self.needsToUpdateViews){
        [self updateViewsFromCurrentObject];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.object = nil;
}

- (void)dealloc
{
    if(_object){
        [self removeUpdateViewsObserversForObject:_object];
    }
}
    
@end
