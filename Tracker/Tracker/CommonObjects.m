//
//  CommonObjects.m
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "CommonObjects.h"


@implementation CommonObjects

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg parentViewController:(UIViewController*)viewController{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:title
                                 message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* retryButton = [UIAlertAction
                                  actionWithTitle:@"Done"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                  }];
    [alert addAction:retryButton];
    [viewController presentViewController:alert animated:YES completion:nil];
}

@end