//
//  MCDManagedObjectObserver.m
//  MHFoundation
//
//  Created by Malcolm Hall on 19/02/2018.
//  Copyright © 2018 Malcolm Hall. All rights reserved.
//

#import "MCDManagedObjectChangeObserver.h"

static void * const kObserverContext = (void *)&kObserverContext;

@implementation MCDManagedObjectChangeObserver

- (instancetype)initWithDelegate:(id<MCDManagedObjectChangeObserverDelegate>)delegate{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)setObject:(id)object{
    if(_object == object) {
        return;
    }
    else if(_object){
        [self removeObserversForObject:_object keyPaths:self.keyPaths];
    }
    _object = object;
    if(object){
        [self addObserversForObject:object keyPaths:self.keyPaths];
    }
}

- (void)setKeyPaths:(NSArray<NSString *> *)keyPaths{
    if(_keyPaths == keyPaths){
        return;
    }
    else if(_keyPaths){
        [self removeObserversForObject:self.object keyPaths:_keyPaths];
    }
    _keyPaths = keyPaths;
    if(keyPaths){
        [self addObserversForObject:self.object keyPaths:keyPaths];
    }
}

- (void)addObserversForObject:(id)object keyPaths:(NSArray *)keyPaths{
    for(NSString *key in keyPaths){
        [object addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:kObserverContext];
    }
}

- (void)removeObserversForObject:(id)object keyPaths:(NSArray *)keyPaths{
    for(NSString *key in keyPaths){
        [object removeObserver:self forKeyPath:key context:kObserverContext];
    }
}

- (void)observeValueForKeyPath:(nullable NSString *)keyPath ofObject:(nullable id)object change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change context:(nullable void *)context{
    if(context != kObserverContext){
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    NSKeyValueChange kind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
    if(kind == NSKeyValueChangeSetting){
        if([change[NSKeyValueChangeNewKey] isEqual:change[NSKeyValueChangeOldKey]]){
            return;
        }
    }
    [self.delegate managedObjectChangeObserver:self didUpdateKeyPath:keyPath];
}

- (void)dealloc
{
    self.object = nil; // removes observers
}

@end
