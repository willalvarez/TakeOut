//
//  OrdersQueueViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/5/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "OrdersQueueViewController.h"

@interface OrdersQueueViewController ()

@end

@implementation OrdersQueueViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = NSLocalizedString(@"Customer Orders", @"Customer Orders");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:) name:@"neworders" object:nil];
    return self;
}

-(void)receiveNotification:(NSNotification *) notification{
    
    NSLog(@"Orders Queue Received Notification from didFinishedLaunch: %@", [notification name]);
    
    NSDictionary *newOrders = [notification userInfo];
    
    if ([[notification name] isEqualToString:@"neworders"]) {
        
        NSString *new_Count = [newOrders objectForKey:@"new_orders"];
        UITabBarController *tabController = self.tabBarController;
        NSArray *tabBarItems = tabController.tabBar.items;
        UITabBarItem *itemToChangeBadge = [tabBarItems objectAtIndex:2];
        [itemToChangeBadge setBadgeValue:new_Count];
    }
        
    }


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom the table
        
        // The className to query on
        self.parseClassName = @"OrderDetail";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"itemName";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
      //  self.paginationEnabled = YES;
        
        // The number of objects to show per page
       // self.objectsPerPage = 10;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
  //  [NSTimer scheduledTimerWithTimeInterval:5.0f
  //                                   target:self selector:@selector(methodB:) userInfo:nil repeats:YES];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}

//////
//////
/*
- (void) methodA
{
    //Start playing an audio file.
    
    //NSTimer calling Method B, as long the audio file is playing, every 5 seconds.
    [NSTimer scheduledTimerWithTimeInterval:30.0f
                                     target:self selector:@selector(methodB:) userInfo:nil repeats:YES];
}

- (void) methodB:(NSTimer *)timer
{
    NSUInteger limit = 0;
    NSUInteger skip = 0;
    PFQuery *query = [PFQuery queryWithClassName:@"tempClass"];
    [query setLimit: limit];
    [query setSkip: skip];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // update badge value for resto owner to see orders coming in
             NSInteger ctr = [self.objects count];
            NSString *string = @(ctr).stringValue;
            UITabBarController *tabController = self.tabBarController;
            NSArray *tabBarItems = tabController.tabBar.items;
            UITabBarItem *itemToChangeBadge;
            itemToChangeBadge = [tabBarItems objectAtIndex:2];
            [itemToChangeBadge setBadgeValue:string];
            

            // The find succeeded. Add the returned objects to allObjects
            if (objects.count == limit) {

                 }
                 
                 } else {
                     // Log details of the failure
                     NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 }];
    [self.view reloadInputViews];
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parse

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    
}

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    // Return the number of rows in the section.
    return [self.objects count];
}
// Override to customize what kind of query to perform on the class. The default is to query for
// all objects ordered by createdAt descending.
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    }
   

    
    
    [query orderByAscending:@"itemName"];

    return query;
}



// Override to customize the look of a cell representing an object. The default is to display
// a UITableViewCellStyleDefault style cell with the label being the first key in the object.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell
    cell.textLabel.text = [object objectForKey:@"itemName"];
    
    
    return cell;
}


/*
 // Override if you need to change the ordering of objects in the table.
 - (PFObject *)objectAtIndex:(NSIndexPath *)indexPath {
 return [objects objectAtIndex:indexPath.row];
 }
 */

/*
 // Override to customize the look of the cell that allows the user to load the next page of objects.
 // The default implementation is a UITableViewCellStyleDefault cell with simple labels.
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
 static NSString *CellIdentifier = @"NextPage";
 
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
 
 if (cell == nil) {
 cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
 }
 
 cell.selectionStyle = UITableViewCellSelectionStyleNone;
 cell.textLabel.text = @"Load more...";
 
 return cell;
 }
 */

#pragma mark - Table view data source

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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
