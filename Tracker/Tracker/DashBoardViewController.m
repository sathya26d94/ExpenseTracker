//
//  DashBoardViewController.m
//  Tracker
//
//  Created by SaTHYa on 24/05/17.
//  Copyright © 2017 SaTHYa. All rights reserved.
//

#import "DashBoardViewController.h"
#import "AddExpenseViewController.h"
#import "CommonObjects.h"
#import "Expense.h"
#import "MOC.h"
#import "Query.h"
#import "NSDate+Date.h"

typedef enum {
    Today = 0,
    LastSevenDays,
    Month
}DashBoardType;

@interface DashBoardViewController () <AddExpenseViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *dashBoardTypePicker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) NSArray *tableArray;
@property (nonatomic, strong) NSMutableArray *dashbordTypeDataArray;
@property (strong, nonatomic) AddExpenseViewController *addExpenseViewController;
@property (nonatomic)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) DashBoardType dashBoardType;
@end

@implementation DashBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.datePicker setMaximumDate:[[NSDate date] endOfDay]];
    self.tableArray = [NSMutableArray arrayWithArray: CatigoriesArray];
    self.dashbordTypeDataArray = [NSMutableArray arrayWithArray: DashBoardTypeArray];
    self.dashBoardType = Today;
    [self initializeFetchedController];
}

- (IBAction)addExpense:(id)sender {
    [self loadAddexpenseView];
}

- (IBAction)dateChanged:(id)sender {
    [self.tableView reloadData];
}

-(void)loadAddexpenseView {
    self.addExpenseViewController = [[AddExpenseViewController alloc] init];
    self.addExpenseViewController.delegate = self;
    [self presentViewController:self.addExpenseViewController animated:YES completion:nil];
}

//AddExpenseViewController delegate methods
-(void)removeAddExppensesViewController {
    [self dismissViewControllerAnimated:YES completion:Nil];
    [self.tableView reloadData];
}

-(void)initializeFetchedController{
    if (self.fetchedResultsController!=nil) {
        self.fetchedResultsController.delegate=nil;
        self.fetchedResultsController=nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey: @"title" ascending: NO]]];
    [fetchRequest setPredicate:nil];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Expense" inManagedObjectContext:[[MOC sharedInstance] childManagedObjectContext]]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[[MOC sharedInstance] childManagedObjectContext] sectionNameKeyPath:nil cacheName:nil];
}

//tableview delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"ExpenseIdentifiers";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
    }
    cell.textLabel.text = self.tableArray[indexPath.row];
    cell.detailTextLabel.text = [self getTotalExpenseForCategory:self.tableArray[indexPath.row]];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//pickerView delegate methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.dashbordTypeDataArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.dashbordTypeDataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.dashBoardType = (int)row;
    if (self.dashBoardType ==  Today) {
        
    } else if (self.dashBoardType ==  Month) {
        [CommonObjects showAlertWithTitle:@"Info" message:@"Select any date in the Month you want to filter" parentViewController:self];
    } else {
        [CommonObjects showAlertWithTitle:@"Info" message:@"Select any date in the week you want to filter" parentViewController:self];
    }
    [self.tableView reloadData];
}

//private methods
- (NSString*)getTotalExpenseForCategory:(NSString*)category {
    if (self.dashBoardType ==  Today) {
        self.fetchedResultsController.fetchRequest.predicate = [[Query sharedInstance] dashBoardFilterQueryForCategory:category startDate:[self.datePicker.date beginningOfDay] endDate:[self.datePicker.date endOfDay]];
    } else if (self.dashBoardType ==  Month) {
        self.fetchedResultsController.fetchRequest.predicate = [[Query sharedInstance] dashBoardFilterQueryForCategory:category startDate:[self.datePicker.date startOfTheMonth] endDate:[self.datePicker.date endOfTheMonth]];
    } else {
        self.fetchedResultsController.fetchRequest.predicate = [[Query sharedInstance] dashBoardFilterQueryForCategory:category startDate:[self.datePicker.date startOfTheWeek] endDate:[self.datePicker.date endOfTheWeek]];
    }
    
    int total = 0;
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    if (error) {
        [CommonObjects showAlertWithTitle:@"Error" message:[error description] parentViewController:self];
    }
    
    for (Expense *expense in self.fetchedResultsController.fetchedObjects) {
        total += expense.amount.doubleValue;
    }
    return [NSString stringWithFormat:@"%d",total];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

