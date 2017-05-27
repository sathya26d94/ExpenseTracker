//
//  AddExpenseViewController.h
//  Tracker
//
//  Created by SaTHYa on 24/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddExpenseViewControllerDelegate <NSObject>
- (void) removeAddExppensesViewController;
@end

@interface AddExpenseViewController : UIViewController
@property (nonatomic, weak)id <AddExpenseViewControllerDelegate> delegate;
@end
