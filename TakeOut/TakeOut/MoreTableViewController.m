//
//  MoreTableViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/10/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "MoreTableViewController.h"
#import "UserViewController.h"
#import "StripeEnrollmentViewController.h"
#import "AmazonS3ViewController.h"

#define CENTER_TAG 1
#define LEFT_PANEL_TAG 2
#define RIGHT_PANEL_TAG 3

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60
#define SHADOW_OFFSET 0.8

@interface MoreTableViewController ()
{
    NSArray *menuItems;
    UserViewController *userViewController;
    StripeEnrollmentViewController *stripeEnrollment;
    AmazonS3ViewController *amazonS3ViewController;
}
@end

@implementation MoreTableViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = NSLocalizedString(@"More", @"TakeOut");
    self.tabBarItem.image = [UIImage imageNamed:@"menu-32.png"];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    menuItems = @[@"User Setup", @"Stripe Enrollment",@"Amazon S3"];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // Configure the cell...
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 0.0,200.0, 30.0)];
    
    textLabel.tag = 4223;
    cell.textLabel.text = menuItems[indexPath.row];
    [cell.contentView addSubview:textLabel];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    switch (indexPath.row)
    
    {
        case 0:
            {
                userViewController = [[UserViewController alloc] initWithNibName:@"UserViewController" bundle:nil];
                [self.view addSubview:userViewController.view];
                [self addChildViewController:userViewController];
                [userViewController didMoveToParentViewController:self];
                    userViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

                UIView *childView = userViewController.view;

                [self.view sendSubviewToBack:childView];
        
                [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                self.view.tag =0 ;
                             }
                         }];

                [self.navigationController pushViewController:userViewController animated:YES];
                break;
            }
        
        case 1:
        {
            stripeEnrollment = [[StripeEnrollmentViewController alloc] initWithNibName:@"StripeEnrollmentViewController" bundle:nil];
            [self.view addSubview:stripeEnrollment.view];
            [self addChildViewController:stripeEnrollment];
            [stripeEnrollment didMoveToParentViewController:self];
            stripeEnrollment.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
            UIView *childView = stripeEnrollment.view;
        
            [self.view sendSubviewToBack:childView];
        
            [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                                }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 self.view.tag =0 ;
                             }
                         }];
        
            [self.navigationController pushViewController:stripeEnrollment animated:YES];
            break;
        }
        case 2:
        amazonS3ViewController = [[AmazonS3ViewController alloc] initWithNibName:@"AmazonS3ViewController" bundle:nil];
        [self.view addSubview:amazonS3ViewController.view];
        [self addChildViewController:amazonS3ViewController];
        [amazonS3ViewController didMoveToParentViewController:self];
        amazonS3ViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        UIView *childView = amazonS3ViewController.view;
        
        [self.view sendSubviewToBack:childView];
        
        [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 
                                 self.view.tag =0 ;
                             }
                         }];
        
        [self.navigationController pushViewController:amazonS3ViewController animated:YES];
        break;

    }
}


@end
