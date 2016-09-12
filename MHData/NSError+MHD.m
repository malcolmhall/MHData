//
//  NSError+MHD.m
//  MHData
//
//  Created by Malcolm Hall on 12/09/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import "NSError+MHD.h"

@implementation NSError (MHD)

-(BOOL)mhd_isValidation{
    if(self.domain != NSCocoaErrorDomain){
        return NO;
    }
    return self.code >= 1550 && self.code <= 1680;
}

- (NSString *)mhd_localizedDisplayDescription{
    
    NSString* message;
    
    if(self.mhd_isValidation){
        NSArray *errors;
        // multiple errors?
        if (self.code == NSValidationMultipleErrorsError) {
            errors = [self.userInfo objectForKey:NSDetailedErrorsKey];
        } else {
            errors = [NSArray arrayWithObject:self];
        }
    
        message = @"Validation Error:\n";
        
        for (NSError * error in errors) {
            NSString *entityName = [[[[error userInfo] objectForKey:@"NSValidationErrorObject"] entity] name];
            NSString *attributeName = [[error userInfo] objectForKey:@"NSValidationErrorKey"];
            NSString *msg;
            switch ([error code]) {
                case NSManagedObjectValidationError:
                    msg = @"Generic validation error.";
                    break;
                case NSValidationMissingMandatoryPropertyError:
                    msg = [NSString stringWithFormat:@"The attribute '%@' mustn't be empty.", attributeName];
                    break;
                case NSValidationRelationshipLacksMinimumCountError:
                    msg = [NSString stringWithFormat:@"The relationship '%@' doesn't have enough entries.", attributeName];
                    break;
                case NSValidationRelationshipExceedsMaximumCountError:
                    msg = [NSString stringWithFormat:@"The relationship '%@' has too many entries.", attributeName];
                    break;
                case NSValidationRelationshipDeniedDeleteError:
                    msg = [NSString stringWithFormat:@"To delete, the relationship '%@' must be empty.", attributeName];
                    break;
                case NSValidationNumberTooLargeError:
                    msg = [NSString stringWithFormat:@"The number of the attribute '%@' is too large.", attributeName];
                    break;
                case NSValidationNumberTooSmallError:
                    msg = [NSString stringWithFormat:@"The number of the attribute '%@' is too small.", attributeName];
                    break;
                case NSValidationDateTooLateError:
                    msg = [NSString stringWithFormat:@"The date of the attribute '%@' is too late.", attributeName];
                    break;
                case NSValidationDateTooSoonError:
                    msg = [NSString stringWithFormat:@"The date of the attribute '%@' is too soon.", attributeName];
                    break;
                case NSValidationInvalidDateError:
                    msg = [NSString stringWithFormat:@"The date of the attribute '%@' is invalid.", attributeName];
                    break;
                case NSValidationStringTooLongError:
                    msg = [NSString stringWithFormat:@"The text of the attribute '%@' is too long.", attributeName];
                    break;
                case NSValidationStringTooShortError:
                    msg = [NSString stringWithFormat:@"The text of the attribute '%@' is too short.", attributeName];
                    break;
                case NSValidationStringPatternMatchingError:
                    msg = [NSString stringWithFormat:@"The text of the attribute '%@' doesn't match the required pattern.", attributeName];
                    break;
                default:
                    msg = [NSString stringWithFormat:@"Unknown error (code %li).", error.code];
                    break;
            }
            
            message = [message stringByAppendingFormat:@"%@%@%@\n", (entityName?:@""), (entityName?@": ":@""), msg];
        }
    }
    else{
        message = self.localizedDescription;
    }
    return message;
}

@end
