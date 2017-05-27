//
//  CommonObjects.h
//  Tracker
//
//  Created by SaTHYa on 27/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CatigoriesArray @[@"Food", @"Fuel", @"Recharge", @"Fashion", @"Cosmetics", @"Entertaiment", @"Others"]
#define DashBoardTypeArray @[@"Daily Wise", @"Weekly Wise", @"Monthly Wise"]

@interface CommonObjects : NSObject
+(void)showAlertWithTitle:(NSString*)title message:(NSString*)msg parentViewController:(UIViewController*)viewController;
@end
