//
//  SecondViewController.m
//  Jimmy
//
//  Created by Angel Flores on 2/24/14.
//  Copyright (c) 2014 Menlo. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self retrieveFacebookEvents];
    self.events = [[NSMutableArray alloc] init];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"setting rows %tu", [self.events count]);
    return [self.events count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"eventCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *event = self.events[indexPath.row];
    
    NSLog(@"%@", event);
    NSLog(@"%@", [event valueForKey:@"name"]);
    NSLog(@"%@", [event valueForKey:@"location"]);
    
    cell.textLabel.text = [event objectForKey:@"name"];
    cell.detailTextLabel.text = [event valueForKeyPath:@"location"];
    
    return cell;
}

- (IBAction)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

- (void)retrieveFacebookEvents
{
    NSDictionary *options = @{ ACFacebookAppIdKey: @"596275250465373", ACFacebookPermissionsKey: @[ @"user_events"] };

    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    [accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
            if(granted)
            {
                for (ACAccount *account in [accountStore accountsWithAccountType:accountType])
                {
                    if([account.username isEqual:self.account.username])
                    {
                        self.account = account;
                    }
                }
                
                NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/events"];
                SLRequest *request = [SLRequest
                                        requestForServiceType: SLServiceTypeFacebook
                                        requestMethod: SLRequestMethodGET
                                        URL: url
                                        parameters:nil];
                [request setAccount: self.account];
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *response, NSError *error) {
                    if(response.statusCode == 200)
                    {
                        NSError *parsingError = nil;
//                        self.events = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parsingError] objectForKey:@"data"];
                        NSMutableArray *facebookEvents = [[NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parsingError] objectForKey:@"data"];

                        for (int i = 0; i < facebookEvents.count; i++) {
                            [self retrieveSingleEvent:facebookEvents[i]];
                        }
//                        dispatch_sync(dispatch_get_main_queue(), ^{
//                            [self.tableView reloadData];
//                        });
                    }
                }];
            }
    }];
}

- (void) retrieveSingleEvent:(NSDictionary *)event
{
    NSMutableString *eventUrlStr = [[NSMutableString alloc] initWithString:@"https://graph.facebook.com/"];
    NSMutableString *eventId = [[NSMutableString alloc] initWithString: [event valueForKey:@"id"]];
    [eventUrlStr appendString:eventId];
    NSURL *eventUrl = [NSURL URLWithString:eventUrlStr];
   
    SLRequest *eventRequest = [SLRequest
                               requestForServiceType:SLServiceTypeFacebook requestMethod:SLRequestMethodGET URL:eventUrl parameters:nil];
    
    [eventRequest setAccount:self.account];
    [eventRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(urlResponse.statusCode == 200)
        {
            NSError *parsingError = nil;
            NSDictionary *myEvent = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parsingError];
            [self.events addObject: myEvent];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
    }];
}
@end
