//
//  EnterOrdersViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/2/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "EnterOrdersViewController.h"
#import <Parse/Parse.h>
#import "Menu.h"

@interface EnterOrdersViewController () <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>
{
NSArray *menusArray;
NSArray *itemsImages;
NSMutableArray *appetizersArray;
NSMutableArray *entreesArray;
NSArray *appetizersImages;
NSArray *entreesImages;
NSString *imagename;
UIScrollView *horizontalScrollView;
NSLayoutConstraint *constraint;
NSDictionary *menu_obj;
}
@property (nonatomic) NSTextAlignment centerAlignment;

@end

@implementation EnterOrdersViewController
@synthesize TakeOutlogo;
@synthesize tableView;
@synthesize buttonAppetizers;
@synthesize buttonEntrees;
@synthesize buttonCorner;
@synthesize itemScrollView;
@synthesize imgView;
@synthesize restoname;
@synthesize done;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveNotification:) name:@"searched_resto" object:nil];

        
        self.title = @"Order";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];

    }
    return self;
}

-(void)receiveNotification:(NSNotification *) notification{
    
    NSLog(@"EnterOrders Received Notification from SearchRestaurants: %@", [notification name]);
    
    NSDictionary *restoInfo = [notification userInfo];
    
    if ([[notification name] isEqualToString:@"searched_resto"]) {
       
        self.restoname = [restoInfo objectForKey:@"resto_name"];
      //  self.title = self.restoname;
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.restoname==nil)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Not too fast"
                                                         message:@"Select a Restaurant first"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];

    }
    [self createLogo];
 //   [imgView removeFromSuperview];
  //  [tableView removeFromSuperview];
    [self createmenuButtons];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // initializers
    self.centerAlignment  = NSTextAlignmentCenter;
    appetizersArray = [NSMutableArray array];

    menusArray = [NSArray array];
    
    PFQuery *menuQuery = [PFQuery queryWithClassName:@"Menu"];
	[menuQuery orderByAscending:@"item_name"];
	[menuQuery whereKey:@"restaurant" equalTo:self.restoname];
    [menuQuery whereKey:@"item_category" equalTo:@"Appetizers"];
    
    [menuQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
                    [appetizersArray addObjectsFromArray:objects];
        }
                 }];
  //  Menu *menu = [[Menu alloc] init];
    
    
   // appetizersArray = @[@"Calamari", @"Onion Rings"];
    appetizersImages = @[@"calamari.jpg",@"onionrings.jpg"];
    entreesImages   = @[@"sashimi.jpg",@"bentobox.jpg",@"chickenteriyaki.jpg",@"shrimptempura.jpg",@"sirloinsteak.jpg",@"sushishasimi.jpeg"];
    
    entreesArray = [NSMutableArray array];
//    entreesArray = @[@"Sashimi", @"Bento Box",@"Chicken Teriyaki",@"Shrimp Tempura",@"Sirloin Steak",@"Sushi/Sashimi Combo"];
    
    PFQuery *entQuery = [PFQuery queryWithClassName:@"Menu"];
	[entQuery orderByAscending:@"item_name"];
	[entQuery whereKey:@"restaurant" equalTo:self.restoname];
    [entQuery whereKey:@"item_category" equalTo:@"Entrees"];
    
    [entQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            [entreesArray addObjectsFromArray:objects];
        }
    }];
    // Do any additional setup after loading the view from its nib.
}

-(void)createLogo
{
    [TakeOutlogo removeFromSuperview];
    TakeOutlogo = [[UILabel alloc] initWithFrame:CGRectMake(325, 50, 400, 55)];
    TakeOutlogo.font = [UIFont fontWithName:@"Futura" size:25];
    TakeOutlogo.backgroundColor = [UIColor clearColor];
    TakeOutlogo.text = @"";
    TakeOutlogo.text = self.restoname;
    TakeOutlogo.textColor = [UIColor blackColor];
    TakeOutlogo.textAlignment = self.centerAlignment;
    [self.view addSubview:TakeOutlogo];
    // auto-center
    TakeOutlogo.translatesAutoresizingMaskIntoConstraints = NO;
    
    constraint = [NSLayoutConstraint constraintWithItem:TakeOutlogo
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:100.0f];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:TakeOutlogo
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-100.0f];
    [self.view addConstraint:constraint];
    

    
}

-(void)createTableView
{
    [imgView removeFromSuperview];
    [itemScrollView removeFromSuperview];
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width, 200)];
    tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    
    //  [self.view addSubview:tableView];
    
}

-(void)createmenuButtons;
{
    //    w =  [(self.view.frame.size.width/2)];
    
    CGFloat menubuttonSize = 150.0f;
    CGFloat btnappetX =  ((self.view.frame.size.width/2)/2) - (menubuttonSize/2);
    buttonAppetizers = [[UIButton alloc] initWithFrame:CGRectMake(btnappetX, 125, menubuttonSize, 40)];
    [buttonAppetizers setBackgroundColor:[UIColor blackColor]];
    [buttonAppetizers setTitle:@"Appetizers" forState:UIControlStateNormal];
    [buttonAppetizers addTarget:self action:@selector(displayAppetizers) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonAppetizers];

    buttonAppetizers.translatesAutoresizingMaskIntoConstraints = NO;
    constraint = [NSLayoutConstraint constraintWithItem:buttonAppetizers
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:btnappetX];
    [self.view addConstraint:constraint];
    
    CGFloat btnentrstX =  (self.view.frame.size.width/2);
    btnentrstX = (btnentrstX*1.5) - (menubuttonSize/2);
    
    buttonEntrees = [[UIButton alloc] initWithFrame:CGRectMake(btnentrstX, 125, menubuttonSize, 40)];
    [buttonEntrees setBackgroundColor:[UIColor blackColor]];
    [buttonEntrees setTitle:@"Entrees" forState:UIControlStateNormal];
    
    [buttonEntrees addTarget:self action:@selector(displayEntrees) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:buttonEntrees];
    buttonEntrees.translatesAutoresizingMaskIntoConstraints = NO;
    //get rightedge of first button
    CGFloat entrsTrail = btnentrstX + menubuttonSize;
    entrsTrail = self.view.frame.size.width - entrsTrail;
    
    
    [self.view addConstraint:constraint];
    
    buttonEntrees.translatesAutoresizingMaskIntoConstraints = NO;
    constraint = [NSLayoutConstraint constraintWithItem:buttonEntrees
                                              attribute:NSLayoutAttributeTrailing
                                              relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTrailing
                                             multiplier:1.0f
                                               constant:-entrsTrail];
    [self.view addConstraint:constraint];
    
    
    
    // Stick a button on the lower-left corner
    CGFloat cbSize = 200.0f;
    CGFloat cX =  self.view.frame.size.width - (cbSize + 20.0f);
    btnentrstX = (btnentrstX*1.5) - (menubuttonSize/2);
    buttonCorner = [[UIButton alloc] initWithFrame:CGRectMake(cX, self.view.frame.size.height, cbSize, 70)];
    [buttonCorner setBackgroundColor:[UIColor blackColor]];
    [buttonCorner setTitle:@"I do UI by code now!!" forState:UIControlStateNormal];
    
    [self.view addSubview:buttonCorner];
    
    constraint = [NSLayoutConstraint constraintWithItem:buttonCorner
                                              attribute:NSLayoutAttributeRight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeRight
                                             multiplier:1.0f
                                               constant:-20.0f];
    [self.view addConstraint:constraint];
    
    
    buttonCorner.translatesAutoresizingMaskIntoConstraints = NO;
    constraint = [NSLayoutConstraint constraintWithItem:buttonCorner
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:-20];
    
    [self.view addConstraint:constraint];
    cbSize = 150.0f;
    cX =  20.0f;
 
    done = [[UIButton alloc] initWithFrame:CGRectMake(20,self.view.frame.size.height -60, cbSize, 40)];
    [done setBackgroundColor:[UIColor blackColor]];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(exit) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:done];
    done.translatesAutoresizingMaskIntoConstraints = NO;
    constraint = [NSLayoutConstraint constraintWithItem:done
                                              attribute:NSLayoutAttributeLeading
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeLeading
                                             multiplier:1.0f
                                               constant:20.0f];
    [self.view addConstraint:constraint];
    
    
    
    constraint = [NSLayoutConstraint constraintWithItem:done
                                              attribute:NSLayoutAttributeBottom
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeBottom
                                             multiplier:1.0f
                                               constant:-20];
    
    [self.view addConstraint:constraint];
    
}

-(void)displayAppetizers
{
    
    
    buttonEntrees.highlighted = NO;
    buttonEntrees.backgroundColor = [UIColor blackColor];
    buttonAppetizers.highlighted = YES;
    buttonAppetizers.backgroundColor = [UIColor blueColor];
    menusArray =    appetizersArray;
    itemsImages = appetizersImages;
    
    [self createTableView];
    
}

-(void)displayEntrees
{
    
    buttonEntrees.highlighted = YES;
    buttonEntrees.backgroundColor = [UIColor blueColor];
    buttonAppetizers.highlighted = NO;
    buttonAppetizers.backgroundColor = [UIColor blackColor];
    menusArray =    entreesArray;
    itemsImages = entreesImages;
    //   [self createHorizontalScroll:itemsImages];
    [self createTableView];
}


-(void)createImageView : (NSString *)imageName

{
    
    [imgView removeFromSuperview];
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(150, 430, 100, 100)];
    self.imgView.backgroundColor = [UIColor blackColor];
    
    imgView.image = [UIImage imageNamed:imageName];
    [self.view addSubview:self.imgView];
    
    
    self.imgView.translatesAutoresizingMaskIntoConstraints = NO;
    constraint = [NSLayoutConstraint constraintWithItem:imgView
                                              attribute:NSLayoutAttributeHeight
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:imgView
                                              attribute:NSLayoutAttributeWidth
                                             multiplier:1.0f
                                               constant:1.0f];
    [imgView addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:imgView
                                              attribute:NSLayoutAttributeCenterX
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeCenterX
                                             multiplier:1.0f
                                               constant:0.0f ];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:imgView
                                              attribute:NSLayoutAttributeTop
                                              relatedBy:NSLayoutRelationEqual
                                                 toItem:self.view
                                              attribute:NSLayoutAttributeTop
                                             multiplier:1.0f
                                               constant:430];
    [self.view addConstraint:constraint];
    
    
}

-(void)exit
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    return [menusArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
     UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0,250.0, 30.0)];
    
    textLabel.tag = 4223;
    
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.0f];
    textLabel.textColor = [UIColor colorWithRed:82.0f/255.0f green:87.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    textLabel.shadowColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
    textLabel.shadowOffset = CGSizeMake(0.0f, 0.5f);
    textLabel.backgroundColor = [UIColor clearColor];
    menu_obj = menusArray[[indexPath row]];
    textLabel.text = [menu_obj valueForKey:@"item_name"];
    [cell.contentView addSubview:textLabel];
    return cell;
}

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    imagename = itemsImages[[indexPath row]];
    // [self createScrollView:imagename];
   // [self createImageView:imagename];
    self.orderItemViewController = [[OrderItemViewController alloc] init];
    menu_obj = menusArray[[indexPath row]];
    self.orderItemViewController.title = [menu_obj valueForKey:@"item_name"];
   // [self presentModalViewController:self.orderItemViewController animated:YES];
    [self addChildViewController:self.orderItemViewController];
    [self.view addSubview:self.orderItemViewController.view];
  // [self presentViewController:self.orderItemViewController animated:YES completion:nil];

}


@end

