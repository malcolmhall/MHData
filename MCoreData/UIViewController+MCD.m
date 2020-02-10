//
//  UIViewController+MCDPersistentContainer.m
//  MCoreData
//
//  Created by Malcolm Hall on 28/11/2019.
//  Copyright © 2019 Malcolm Hall. All rights reserved.
//

#import "UIViewController+MCD.h"

@implementation UIViewController (MCDPersistentContainer)

- (NSPersistentContainer *)mcd_persistentContainerWithSender:(id)sender{
    UIViewController *target = [self targetViewControllerForAction:@selector(mcd_persistentContainerWithSender:) sender:sender];
    if (target) {
        return [target mcd_persistentContainerWithSender:sender];
    } else {
        return nil;
    }
}

@end
