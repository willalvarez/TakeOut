//
//  MyOrdersTableViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/4/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "MyOrdersTableViewController.h"
#import <Parse/Parse.h>

@interface MyOrdersTableViewController ()
{
    NSNumber *receivedQty;
        SEL savePressed;
    UITabBarItem *itemToChangeBadge;
}
@end

@implementation MyOrdersTableViewController
@synthesize managedObjectContext;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:) name:@"ordered_qty" object:nil];
        
        
        self.title = @"My Orders";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        
        self.title = NSLocalizedString(@"My Orders", @"My Orders");
        self.tabBarItem.image = [UIImage imageNamed:@"80-shopping-cart.png"];
        
    }
    return self;
}

-(void)receiveNotification:(NSNotification *) notification{
    
    NSLog(@"EnterOrders Received Notification from OrderItemViewController: %@", [notification name]);
    
    NSDictionary *qtyInfo = [notification userInfo];
    
    if ([[notification name] isEqualToString:@"ordered_qty"]) {
        
        receivedQty = [qtyInfo objectForKey:@"item_qty"];
        
        self.totalQtys = [NSNumber numberWithFloat:([self.totalQtys floatValue] + [receivedQty floatValue])];
        NSString *convertNumber = [self.totalQtys stringValue];

        UITabBarController *tabController = self.tabBarController;
        NSArray *tabBarItems = tabController.tabBar.items;
        itemToChangeBadge = [tabBarItems objectAtIndex:3];
        [itemToChangeBadge setBadgeValue:convertNumber];
        // Save in context, until user completes order
        
        OrderDetail *orderDetail = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"OrderDetail"
                                    inManagedObjectContext:managedObjectContext];
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *myNumber = [f numberFromString:@"2"];
        
        orderDetail.itemName = [qtyInfo objectForKey:@"item_name"];
        NSDecimalNumber *decNum = [NSDecimalNumber decimalNumberWithDecimal:[receivedQty decimalValue]];
        orderDetail.itemQty = decNum;
        orderDetail.orderNumber = myNumber;

        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"OrderDetail"];
    self.currentItems = [NSMutableArray array];
    
    self.currentItems = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [tableView removeFromSuperview];
    [self createTableView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
      savePressed = @selector(save);
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Complete"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:savePressed];
    
    self.navigationItem.rightBarButtonItems = @[self.editButtonItem, saveButton];

}

-(void)save
{
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
   // Save in Backend database (Parse) , notify OrderFullFillmentViewController
   
    for (int i=0;i<[self.currentItems count]; i++)
    {
        
        OrderDetail *od = [self.currentItems objectAtIndex:i];
        PFObject *order = [PFObject objectWithClassName:@"OrderDetail"];
        [order setObject:od.itemName forKey:@"itemName"];
        [order setObject:od.itemQty forKey:@"itemQty"];
        [order setObject:od.orderNumber forKey:@"orderNumber"];



    
    // Upload order to Parse
    [order saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    }];
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the order" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }

}
    [self.view removeFromSuperview];
    [itemToChangeBadge setBadgeValue:nil];

     [self.tabBarController setSelectedIndex:0];
}


-(void)createTableView
{

    tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width, 200)];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    //  [self.view addSubview:tableView];
    
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
    return [self.currentItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    OrderDetail *od = [self.currentItems objectAtIndex:indexPath.row];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 0.0,200.0, 30.0)];
    
    textLabel.tag = 4223;
    cell.textLabel.text = od.itemName;
    [cell.contentView addSubview:textLabel];
    
    UILabel *textLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(300.0, 0.0,200.0, 30.0)];
    textLabel.tag = 4224;
    textLabel2.text = [od.itemQty stringValue];
    [cell.contentView addSubview:textLabel2];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
