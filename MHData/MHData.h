//
//  MHData.h
//  MHData
//
//  Created by Malcolm Hall on 07/06/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

//! Project version number for MHData.
FOUNDATION_EXPORT double MHDataVersionNumber;

//! Project version string for MHData.
FOUNDATION_EXPORT const unsigned char MHDataVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <MHData/PublicHeader.h>

#import <MHData/MHDDefines.h>

#import <MHData/NSManagedObjectContext+MHD.h>
#import <MHData/NSManagedObjectModel+MHD.h>
#import <MHData/NSPersistentStoreCoordinator+MHD.h>
#import <MHData/NSManagedObject+MHD.h>
#import <MHData/NSEntityDescription+MHD.h>
#import <MHData/NSError+MHD.h>

#import <MHData/MHDStackManager.h>
#import <MHData/MHDPersistentStoreBridge.h>
#import <MHData/MHDFetchedResultsViewController.h>
#import <MHData/MHDFetchedResultsController.h>

#import <MHData/MHDPersistentContainer.h>
#import <MHData/MHDPersistentStoreDescription.h>