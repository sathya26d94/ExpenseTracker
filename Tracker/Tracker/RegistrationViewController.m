//
//  ViewController.m
//  Tracker
//
//  Created by SaTHYa on 24/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "RegistrationViewController.h"
#import "DashBoardViewController.h"
#import "NSString+String.h"
#import "CommonObjects.h"

@interface RegistrationViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (strong, nonatomic) DashBoardViewController *dashBoardViewController;
@property (assign) BOOL isLogin;
@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.delegate = self.password.delegate = self;
    NSString *emailValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"email"];
    if (emailValue) {
        [self.registerButton setTitle:@"Login" forState: UIControlStateNormal];
        self.email.hidden = self.emailLabel.hidden = self.isLogin = true;
    } else {
        [self.registerButton setTitle:@"Registration" forState: UIControlStateNormal];
        self.email.hidden = self.emailLabel.hidden = self.isLogin = false;
    }
    NSLog(@"%@",[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory  inDomains:NSUserDomainMask] lastObject]);
}

- (IBAction)registerButtonPressed:(id)sender {
    if (self.isLogin) {
        NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username"];
        NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
        if ([username isEqualToString:self.userName.text] && [password isEqualToString:self.password.text]) {
            [self loadDashBoard];
        } else {
            [CommonObjects showAlertWithTitle:@"Info" message:@"Incorrect username or password" parentViewController:self];
        }
    } else {
        if ([self.email.text isValidEmail]) {
            if ([self.userName.text isValidUserNameOrPassword] && [self.password.text isValidUserNameOrPassword]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.userName.text forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"password"];
                [[NSUserDefaults standardUserDefaults] setObject:self.email.text forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self loadDashBoard];
            } else {
                [CommonObjects showAlertWithTitle:@"Info" message:@"Username/Password should be atleast 6 characters" parentViewController:self];
            }
        } else {
            [CommonObjects showAlertWithTitle:@"Info" message:@"Enter valid Email" parentViewController:self];
        }
    }
}

-(void)loadDashBoard {
    self.dashBoardViewController = [[DashBoardViewController alloc] init];
    [self presentViewController:self.dashBoardViewController animated:YES completion:nil];
}

//UITextField delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
