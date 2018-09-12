//
//  MCDManagedObjectTableViewCell.m
//  MCoreData
//
//  Created by Malcolm Hall on 27/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDTableViewCell.h"
#import "MCDFetchedTableViewController.h"

static void * const kUpdateViewsContext = (void *)&kUpdateViewsContext;

@interface MCDTableViewCell ()
@property (nonatomic) BOOL needsToUpdateViews;
@end

@implementation MCDTableViewCell

- (void)setObject:(NSManagedObject<MCDTableViewCellObject> *)object{
    if(_object == object){
        return;
    }
    else if(_object){
        //[self removeUpdateViewsObserversForObject:_object];
//        [NSNotificationCenter.defaultCenter removeObserver:self name:MCDFetchedTableViewControllerObjectUpdated object:_object];
    }
    _object = object;
    if(object){
        //[self addUpdateViewsObserversForObject:object];
       // [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(objectChanged:) name:MCDFetchedTableViewControllerObjectUpdated object:object];
    }
    [self updateViewsFromCurrentObjectIfNecessary];
}

- (void)objectChanged:(NSNotification *)notification{
     [self updateViewsFromCurrentObjectIfNecessary];
}

//- (void)addUpdateViewsObserversForObject:(NSManagedObject<MCDTableViewCellObject> *)object{
//    [object addObserver:self forKeyPath:NSStringFromSelector(@selector(titleForTableViewCell)) options:0 context:kUpdateViewsContext];
//    if([object respondsToSelector:@selector(subtitleForTableViewCell)]){
//        [object addObserver:self forKeyPath:NSStringFromSelector(@selector(subtitleForTableViewCell)) options:0 context:kUpdateViewsContext];
//    }
//}

//- (void)removeUpdateViewsObserversForObject:(NSObject<MCDTableViewCellObject> *)object{
//    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(titleForTableViewCell)) context:kUpdateViewsContext];
//    if([object respondsToSelector:@selector(subtitleForTableViewCell)]){
//        [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(subtitleForTableViewCell)) context:kUpdateViewsContext];
//    }
//}

// propertiesToFetch must be set to prevent this being called when the object fault is fired.
//- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
//    if(context != kUpdateViewsContext){
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        return;
//    }
//    NSManagedObject *o = (NSManagedObject *)object;
//    if(o.faultingState){
//        return;
//    }
//
//}

- (void)updateViewsFromCurrentObject{
    //if([self.viewedObject respondsToSelector:@selector(titleForTableViewCell)]){
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
//- (void)didMoveToWindow{
    if(window && self.needsToUpdateViews){
    //if(self.needsToUpdateViews){
        [self updateViewsFromCurrentObject];
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    self.object = nil;
    self.needsToUpdateViews = NO;
}

- (void)dealloc
{
//    if(_object){
//        [self removeUpdateViewsObserversForObject:_object];
//    }
}

@end
