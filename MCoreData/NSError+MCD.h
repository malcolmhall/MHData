//
//  NSError+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 12/09/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

@interface NSError (MCD)

- (NSDictionary *)mcd_validationDescriptionsByEntityName;

// shows validation errors as messages, otherwise defaults to localizedDescription.
- (NSString *)mcd_readableDescription;

- (BOOL)mcd_isValidation;

- (BOOL)mcd_isConstraintMergeError;

@end
