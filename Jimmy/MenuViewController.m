//
//  MenuViewController.m
//  Jimmy
//
//  Created by Angel Flores on 2/24/14.
//  Copyright (c) 2014 Menlo. All rights reserved.
//

#import "MenuViewController.h"
#import "HomeViewController.h"
#import "SecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "NavigationController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.accounts = [[NSMutableArray alloc] init];
    NSLog(@"menu view did load");
    NSDictionary *facebookOptions = @{ ACFacebookAppIdKey: @"596275250465373", ACFacebookPermissionsKey: @[@"email", @"user_events"] };
    [self retrieveAccounts:ACAccountTypeIdentifierFacebook options:facebookOptions];
    
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 44.0f)];
        view;
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f green:68/255.0f blue:75/255.0f alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f green:167/255.0f blue:167/255.0f alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Accounts";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];
    
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        HomeViewController *homeViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"homeController"];
//        navigationController.viewControllers = @[homeViewController];
//    } else {
//        SecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
//        navigationController.viewControllers = @[secondViewController];
//    }
    
    ACAccount *account = [self.accounts objectAtIndex:indexPath.row];
    
    SecondViewController *secondViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"secondController"];
    secondViewController.account = account;
    navigationController.viewControllers = @[secondViewController];
    
    self.frostedViewController.contentViewController = navigationController;
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSLog(@"setting rows %tu", [self.accounts count]);
    return [self.accounts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"accountCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    ACAccount *account = self.accounts[indexPath.row];
    
    cell.textLabel.text = account.accountDescription;
    
//    NSArray *titles = @[@"John Appleseed", @"John Doe", @"Test User"];
//    cell.textLabel.text = titles[indexPath.row];
    
    return cell;
}

/**
 * Accounts
 */
-(void) retrieveAccounts:(NSString *)identifier options:(NSDictionary *)options
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:identifier];
    
    NSLog(@"requesting access");
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error)
     {
         if(granted)
         {
             [self.accounts addObjectsFromArray:[accountStore accountsWithAccountType:accountType]];
             NSLog(@"updating rows %tu", [self.accounts count]);
             NSLog(@"%@", [accountStore accountsWithAccountType:accountType]);
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self.tableView reloadData];
             });
         }
         else {
             NSLog(@"%@", error);
         }
     }];
}

@end
