//
//  NSString+String.m
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "NSString+String.h"

@implementation NSString(String)

-(BOOL)isValidEmail {
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isValidUserNameOrPassword {
    if ([self length] > 5) {
        return true;
    } else {
        return false;
    }
}

-(BOOL)isValidTitle {
    if ([self length] < 20) {
        return true;
    } else {
        return false;
    }
}

@end
