//
//  AddExpenseViewController.m
//  Tracker
//
//  Created by SaTHYa on 24/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "AddExpenseViewController.h"
#import "Expense.h"
#import "MOC.h"
#import "CommonObjects.h"
#import "NSString+String.h"
#import "NSDate+Date.h"

@interface AddExpenseViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property(nonatomic,strong) NSArray *tableArray;
@property(nonatomic,strong) NSMutableString *selectedCategories;

@end

@implementation AddExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableArray = [NSMutableArray arrayWithArray: CatigoriesArray];
    [self.tableView reloadData];
    [self.datePicker setMaximumDate:[[NSDate date] endOfDay]];
    self.titleTextField.delegate = self.amountTextField.delegate = self.amountTextField.delegate = self;
    self.selectedCategories = [NSMutableString string];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePressed:(id)sender {
    if ([self.titleTextField.text isEqualToString:@""] || [self.amountTextField.text isEqualToString:@""]) {
        [CommonObjects showAlertWithTitle:@"Info" message:@"Kindly enter Title/Amount" parentViewController:self];
    } else if(![self.titleTextField.text isValidTitle]) {
        [CommonObjects showAlertWithTitle:@"Info" message:@"Title should be less than 20 characters" parentViewController:self];
    } else if([self.selectedCategories isEqualToString:@""]) {
        [CommonObjects showAlertWithTitle:@"Info" message:@"Choose atleast one Category" parentViewController:self];
    } else {
        Expense *expense=[NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext: [[MOC sharedInstance] childManagedObjectContext]];
        expense.title = self.titleTextField.text;
        expense.amount = [NSNumber numberWithFloat:[self.amountTextField.text floatValue]];
        expense.notes = self.notesTextField.text;
        expense.date = [NSDate date];
        expense.categories = self.selectedCategories;
        [[MOC sharedInstance] saveChildContext:^(id responseObjects) {
            [self.delegate removeAddExppensesViewController];
        } error:^(NSString *failureReason) {
            [CommonObjects showAlertWithTitle:@"Error" message:failureReason parentViewController:self];
        }];
    }
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate removeAddExppensesViewController];
}

//tableview delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"identifiers";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
    }
    cell.textLabel.text=self.tableArray[indexPath.row];
    cell.separatorInset=UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark) {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedCategories stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@",%@",self.tableArray[indexPath.row]] withString:@""];
    } else {
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedCategories appendString:[NSString stringWithFormat:@", %@",self.tableArray[indexPath.row]]];
    }
}

//UITextField delegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
