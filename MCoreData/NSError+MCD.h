//
//  NSError+MCD.h
//  MCoreData
//
//  Created by Malcolm Hall on 12/09/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MCoreData/MCDDefines.h>

@interface NSError (MCD)

@property (strong, nonatomic, readonly) NSDictionary *mcd_validationDescriptionsByEntityName;

// shows validation errors as messages, otherwise defaults to localizedDescription.
@property (strong, nonatomic, readonly) NSString *mcd_readableDescription;

@property (assign, nonatomic, readonly) BOOL mcd_isValidationError;

@property (assign, nonatomic, readonly) BOOL mcd_isConstraintMergeError;

@end
