//
//  SecondViewController.h
//  Jimmy
//
//  Created by Angel Flores on 2/24/14.
//  Copyright (c) 2014 Menlo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface SecondViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong , nonatomic) ACAccount *account;
@property (strong, nonatomic) NSMutableArray *events;

- (IBAction)showMenu;

@end
