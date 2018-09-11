//
//  AppDelegate.m
//  MCoreDataDemo
//
//  Created by Malcolm Hall on 15/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "MasterViewController.h"
#import "InitialViewController.h"

// Finder behaviour is not to select anything when going in subfolder.
// Notes always picks the first note.
// Mail remembers previous selected email in the folder.
// Think its best that something is always selected cause saves a tap.

// What was that stuff to do with needing to show detail from the venue list?
// Was using sender. Maybe to do with deletes?
// Probably to do with deleting Folders.

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@interface UISplitViewController ()

- (void)_willShowCollapsedDetailViewController:(id)a inTargetController:(id)b;

@end

@interface UINavigationController ()
- (id)separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController;
@end

@implementation AppDelegate

// must not do anything that causes views to load in here.
- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

//- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //NSURL *url = [MCDNSPersistentContainer defaultDirectoryURL];
    
    //NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
  //  MCDBackgroundContextOperation *op = [[MCDBackgroundContextOperation alloc] init];
    
    self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;
    
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    
    
    UINavigationController *navigationController = splitViewController.viewControllers.lastObject;
    //navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;

   // id i = splitViewController.viewControllers;
    UINavigationController *masterNavigationController = splitViewController.viewControllers.firstObject;//[0];
    id j = masterNavigationController.viewControllers;
    InitialViewController *controller = (InitialViewController *)masterNavigationController.viewControllers.firstObject;// topViewController
    controller.managedObjectContext = self.persistentContainer.viewContext;
    controller.persistentContainer = self.persistentContainer;
    
    //MasterViewController.managedObjectContext = self.persistentContainer.viewContext;
   // DetailViewController.managedObjectContext = self.persistentContainer.viewContext;
    
//    [UIApplication registerObjectForStateRestoration:self.persistentContainer.viewContext restorationIdentifier:@"Context"];
    
   // UINavigationController *secondaryNavigationController = splitViewController.viewControllers.lastObject;;
   // DetailViewController *detail = (DetailViewController *)secondaryNavigationController.viewControllers.firstObject;
   // id i = detail.view;
  //  detail.managedObjectContext = self.persistentContainer.viewContext;
    
    //controller.persistentContainer = self.persistentContainer;
    
   // controller.fetchItem = [@{@"sectionKey" : @"a"} mutableCopy];
   // [self performSelector:@selector(malc:) withObject:controller afterDelay:1];
    
    
    //NSManagedObjectContext * c1 = self.persistentContainer.newBackgroundContext;
 //   [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
  //  splitViewController.delegate = self;
    // must be done here because causes views to load.
    splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    return YES;
}

- (void)malc:(MasterViewController *)controller{
 //   NSMutableDictionary *d = controller.fetchItem;
    //d[@"sectionKey"] = @"b";
 //   [d setValue:@"b" forKeyPath:@"sectionKey"];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

//- (void)application:(UIApplication *)application willEncodeRestorableStateWithCoder:(NSCoder *)coder{
//    
//}

- (UISplitViewController *)splitViewController{
    return (UISplitViewController *)self.window.rootViewController;
}

// in the case of restored in master portrait, the detail in the storyboard cause a collapse, so whats the point in preventing a collapse when detail portrait?
// if just giving detail navigation it doesnt seem to automatically find the controller below it.
- (UIViewController *)application:(UIApplication *)application viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder{
    NSLog(@"viewControllerWithRestorationIdentifierPath %@", identifierComponents.lastObject);
    //return nil;
    //UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//    if([identifierComponents.lastObject isEqualToString:@"DetailViewController"]){
//        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
//        UINavigationController *secondaryNavigationController = splitViewController.viewControllers.lastObject;;
//        DetailViewController *detail = (DetailViewController *)secondaryNavigationController.viewControllers.firstObject;
//        NSURL *objectURI = [coder decodeObjectForKey:@"object"];
//        if(objectURI){
//            NSManagedObjectContext *moc = self.persistentContainer.viewContext;
//            NSManagedObjectID *objectID = [moc.persistentStoreCoordinator managedObjectIDForURIRepresentation:objectURI];
//            NSManagedObject *object = [moc objectWithID:objectID];
//            detail.object = object;
//        }
        // attempt to workaround a bug for _preservedDetailController not being restored.
        //[splitViewController _willShowCollapsedDetailViewController:secondaryNavigationController inTargetController:nil];
//        return nil;
//    }
//    else
    
//    if([identifierComponents.lastObject isEqualToString:@"SplitViewController"]){
//        return UISplitViewController.alloc.init;
//    }
//    if([identifierComponents.lastObject isEqualToString:@"InitialViewController"]){
//        return self.splitViewController;
//    }
    //else
    //return nil;
    // if we don't restore this then collapse is called.
    if([identifierComponents.lastObject isEqualToString:@"DetailNavigationController"]){
        UINavigationController *secondaryNavigationController = self.splitViewController.viewControllers.lastObject;
        NSLog(@"First %@", secondaryNavigationController);
        //DetailViewController *detail = (DetailViewController *)secondaryNavigationController.viewControllers.firstObject;
        //UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
        //UINavigationController *secondaryNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"DetailNavigationController"];
        return secondaryNavigationController;
    }
    else if([identifierComponents.lastObject isEqualToString:@"DetailViewController"]){
        UINavigationController *secondaryNavigationController = self.splitViewController.viewControllers.lastObject;
        DetailViewController *detail = secondaryNavigationController.viewControllers.firstObject;
       // UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
       // DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
        NSURL *objectURI = [coder decodeObjectForKey:DetailViewControllerDetailObjectKey];
        if(objectURI){
            NSManagedObject *object = [self.persistentContainer.viewContext mcd_existingObjectWithURI:objectURI error:nil];
            if(object){
                detail.event = object;
            }
        }
        return detail;
    }
    else if([identifierComponents.lastObject isEqualToString:@"MasterViewController"]){
        // no longer called
        UIStoryboard *storyboard = [coder decodeObjectForKey:UIStateRestorationViewControllerStoryboardKey];
        MasterViewController *master = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
        master.managedObjectContext = self.persistentContainer.viewContext;
        NSURL *objectURI = [coder decodeObjectForKey:MasterViewControllerDetailObjectKey];
        if(objectURI){
            NSManagedObject *object = [self.persistentContainer.viewContext mcd_existingObjectWithURI:objectURI error:nil];
            if(object){
                [master setMasterItem:object deleteCache:NO];
            }
        }
        return master;
    }
    return nil;
}

#pragma mark - Split view

// if searching storyboard then:
// not called for portrait->portrait
// is called from landscape->portrait
// I think we need it to be called in all cases for the seperate to work.
// When in lanscape, choose and event, go back to venue, rotate to portrait, bug hiearchy is VEnues->Detail
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] &&
        [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] &&
        ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] mcd_detailObject] == nil)){
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    }
    // we need the preserved controller to keep showing the detail so when we seperate again it appears.
//    else if([primaryViewController isKindOfClass:[UINavigationController class]] &&
//            [[(UINavigationController *)primaryViewController topViewController] isKindOfClass:[InitialViewController class]]){
//        // we had gone back to venues list.
//        return YES;
//    }
    else {
        return NO;
    }
}

// if this is nil then when in portrate, on events list go in landscape. VEnues is on left and Events are on right.

// if currently on master it puts the preserved on the right side.
// default behavior pops the nav's top controller and puts it on the right, which isnt right when on Events vc.
// if state was encoded as portrait then this is called because the state is restored as portrait then switched back to landscape. Because it wasn't collapsed we can't use default behavior.
- (nullable UIViewController *)splitViewController:(UISplitViewController *)splitViewController separateSecondaryViewControllerFromPrimaryViewController:(UIViewController *)primaryViewController{
   // id p = primaryViewController.parentViewController;
    
 //  id i = splitViewController.viewControllers;
//    return [i lastObject];
   // return nil;
    /*
    for(UIViewController *vc in [(UINavigationController *)primaryViewController viewControllers]){
        NSLog(@"%@", vc);
        if(![vc isKindOfClass:UINavigationController.class]){
            continue;
        }
        UINavigationController *u = (UINavigationController *)vc;
         for(UIViewController *dd in [u viewControllers]){
            if(![dd isKindOfClass:DetailViewController.class]){
                continue;
            }
            DetailViewController *c = (DetailViewController *)dd;
            id f = c.viewedObject;
            NSLog(@"");
         }
    }
    
    UINavigationController *d = [primaryViewController separateSecondaryViewControllerForSplitViewController:splitViewController];
    NSLog(@"Second %@", d);
    for(UIViewController *vc in d.viewControllers){
        NSLog(@"%@", vc);
        DetailViewController *c = (DetailViewController *)vc;
        id f = c.viewedObject;
        NSLog(@"");
    }
    return d;
    */
    UINavigationController *nav = (UINavigationController *)primaryViewController;
    UIViewController *vc = nav.topViewController;
    if([vc isKindOfClass:UINavigationController.class]){
        return nil;
    }
    
    //return [UINavigationController.alloc initWithRootViewController:UIViewController.alloc.init];
    UINavigationController *nav2 = [splitViewController.storyboard instantiateViewControllerWithIdentifier:@"DetailNavigationController"];
    // if display is full screen can end up in screen can't get back from.
    nav2.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    return nav2;
    //id s = [splitViewController performSelector:@selector(_impl)];
   // id t = [s performSelector:@selector(_preservedDetailController)];
//
//   // if([splitViewController valueForKey:@"_preservedDetailController"]){
//    id i = splitViewController.viewControllers;
//      //  return nil;
//    //}

}

#pragma mark - Core Data stack

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.malhal.MCoreDataDemo" in the application's documents directory.
    return [[NSFileManager.defaultManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/*
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MCoreDataDemo" withExtension:@"momd"];
    _managedObjectModel = [NSManagedObjectModel.alloc initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [NSPersistentStoreCoordinator.alloc initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MCoreDataDemo.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [NSManagedObjectContext.alloc initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}
 */

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (MCDPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            //NSURL *def = [MCDNSPersistentContainer defaultDirectoryURL];
            _persistentContainer = [MCDPersistentContainer.alloc initWithName:@"MCoreDataDemo"];
            NSLog(@"%@", self.applicationDocumentsDirectory.absoluteString);
            //NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Test2.sqlite"];
           // MCDNSPersistentStoreDescription* d = [MCDNSPersistentStoreDescription persistentStoreDescriptionWithURL:storeURL];
            //_persistentContainer.persistentStoreDescriptions = @[d];
            //_persistentContainer.persistentStoreCoordinator.mcd_persistentContainer = _persistentContainer;
         //   [_persistentContainer backupPersistentStore];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull storeDescription, NSError * _Nullable error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
            _persistentContainer.viewContext.automaticallyMergesChangesFromParent = YES;
        }
    }
    
    return _persistentContainer;
}


#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.persistentContainer.viewContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



@end
