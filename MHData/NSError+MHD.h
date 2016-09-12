//
//  NSError+MHD.h
//  MHData
//
//  Created by Malcolm Hall on 12/09/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MHData/MHDDefines.h>

@interface NSError (MHD)

- (NSString *)mhd_displayDescription;

-(BOOL)mhd_isValidation;

@end
