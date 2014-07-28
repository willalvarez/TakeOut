//
//  OrderFulfillmentViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/2/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "OrderFulfillmentViewController.h"

@interface OrderFulfillmentViewController ()

@end

@implementation OrderFulfillmentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Order Queue", @"Order Queue");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
