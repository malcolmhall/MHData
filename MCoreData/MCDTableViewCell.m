//
//  MCDManagedObjectTableViewCell.m
//  MCoreData
//
//  Created by Malcolm Hall on 27/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDTableViewCell.h"

static void * const kUpdateViewsContext = (void *)&kUpdateViewsContext;

@interface MCDTableViewCell ()
@property (nonatomic) BOOL needsToUpdateViews;
@end

@implementation MCDTableViewCell

- (void)setObject:(NSObject<MCDTableViewCellObject> *)object{
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

- (void)addUpdateViewsObserversForObject:(NSObject<MCDTableViewCellObject> *)object{
    //[o addObserver:@"" forKeyPath:@"" options:0 context:0];
    for(NSString *keyPath in object.keysForTableViewCell){
        [object addObserver:self forKeyPath:keyPath options:0 context:kUpdateViewsContext];
    }
}

- (void)removeUpdateViewsObserversForObject:(NSObject<MCDTableViewCellObject> *)object{
    for(NSString *keyPath in object.keysForTableViewCell){
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
    if([self.object respondsToSelector:@selector(titleForTableViewCell)]){
        self.textLabel.text = self.object.titleForTableViewCell;
    }
    if([self.object respondsToSelector:@selector(subtitleForTableViewCell)]){
        self.detailTextLabel.text = self.object.subtitleForTableViewCell;
    }
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
