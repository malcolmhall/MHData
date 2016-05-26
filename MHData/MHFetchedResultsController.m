//
//  MHFetchedResultsController.m
//  MHData
//
//  Created by Malcolm Hall on 04/01/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <MHData/MHFetchedResultsController.h>

@interface MHFetchedResultsController()<NSFetchedResultsControllerDelegate>

@property (nonatomic, assign) id<NSFetchedResultsControllerDelegate> actualDelegate;

//@property (nullable, nonatomic, readonly) NSArray<id<NSFetchedResultsSectionInfo>> *actualSections;

@property (nonatomic, assign) BOOL fetching;

@end

@implementation MHFetchedResultsController

@synthesize actualDelegate = _actualDelegate;
//@synthesize actualSections = _actualSections;

//- (instancetype)initWithFetchRequest:(NSFetchRequest *)fetchRequest managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(nullable NSString *)sectionNameKeyPath cacheName:(nullable NSString *)name{
//    self = [super initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:sectionNameKeyPath cacheName:name];
//    if (self) {
//        
//    }
//    return self;
//}

-(void)setDelegate:(id<NSFetchedResultsControllerDelegate>)delegate{
    _actualDelegate = delegate;
    super.delegate = self;
}

- (id)delegate {
    return self;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.actualDelegate respondsToSelector:aSelector]) {
        return self.actualDelegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.actualDelegate respondsToSelector:aSelector];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    if(self.fetching){
        return;
    }
    [self.actualDelegate controllerWillChangeContent:controller];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    if(self.fetching){
        return;
    }
    [self.actualDelegate controllerDidChangeContent:controller];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath{

    if(self.fetching){
        return;
    }
    
    // sort the section if there is a new index to calculate and we have a comparator.
    if(newIndexPath && self.postFetchComparator){
        id<NSFetchedResultsSectionInfo> section = super.sections[newIndexPath.section];
        NSMutableArray* objects = (NSMutableArray*)section.objects;
        [objects sortUsingComparator:self.postFetchComparator];
        // replace the index
        newIndexPath = [NSIndexPath indexPathForRow:[objects indexOfObject:anObject] inSection:newIndexPath.section];
    }
    
    [self.actualDelegate controller:controller didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
}

-(BOOL)performFetch:(NSError * _Nullable __autoreleasing *)error{
    if(![super performFetch:error]){
        return NO;
    }

    if(!self.postFetchComparator){
        return YES;
    }
    
    self.fetching = YES;
    
    // trick to make the section array mutable so it can be sorted. It's done by a fake delete. The section array only becomes mutable after the first change.
    // todo optimise by reusing undo for multiple sections
    NSManagedObjectContext* context = self.managedObjectContext;
    for(id<NSFetchedResultsSectionInfo> section in super.sections){
        if(!section.numberOfObjects){
            // we don't need to handle sections that have no objects because they will become mutable when the first object is added.
            continue;
        }

        NSManagedObject* obj = section.objects.firstObject;
        
        NSUndoManager* undoManager;
        if(!obj.managedObjectContext.undoManager){
            undoManager = [[NSUndoManager alloc] init];
            obj.managedObjectContext.undoManager = undoManager;
        }
        // start a group incase there already was a manager
        [context.undoManager beginUndoGrouping];
        [context deleteObject:obj];
        [context processPendingChanges];
        [context.undoManager endUndoGrouping];
        [context.undoManager undo];
        // if we created a manager because it was nil then set it back to nil.
        if(undoManager){
            obj.managedObjectContext.undoManager = nil;
        }
        // now we will have a mutable array.
        NSMutableArray* objects = (NSMutableArray*)section.objects;
        [objects sortUsingComparator:self.postFetchComparator];
    }

    self.fetching = NO;
    
    return YES;
}

@end
