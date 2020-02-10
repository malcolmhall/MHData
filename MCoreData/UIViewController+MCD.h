//
//  UIViewController+MCDPersistentContainer.h
//  MCoreData
//
//  Created by Malcolm Hall on 28/11/2019.
//  Copyright © 2019 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <MCoreData/MCDDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MCD)

- (__kindof NSPersistentContainer *)mcd_persistentContainerWithSender:(id)sender;

@end

NS_ASSUME_NONNULL_END
