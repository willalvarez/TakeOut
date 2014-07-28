//
//  OrderItemViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/3/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "OrderItemViewController.h"


@interface OrderItemViewController ()
{
    NSNumber *aggretateNumber;
}
@property NSInteger *running;
@end

@implementation OrderItemViewController
@synthesize runningQty;
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = self.title;
    }
    return self;
}
-(void)viewDidDisappear:(BOOL)animated
{
    [self.view removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Top Title text %@", self.navigationController.navigationBar.topItem.title);
    self.navigationController.navigationBar.topItem.title = self.title;
    self.navigationItem.title = self.title;
    self.labelItem.text = self.title;
    NSLog(@"Running Qty viewWillApear %@", runningQty);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"Product to order %@", self.title);
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)addItemQty:(id)sender
{
    //Notify MyOrder to reflect Quantity on the tabBarItem

    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *myNumber = [f numberFromString:self.itemQuantity.text];

    
    self.runningQty = [NSNumber numberWithFloat:([self.runningQty floatValue] + [myNumber floatValue])];
    
    NSMutableDictionary *orderQty =[[NSMutableDictionary alloc]initWithCapacity:2];
   [orderQty setObject:self.runningQty forKey:@"item_qty"];
    [orderQty setObject:self.title forKey:@"item_name"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ordered_qty" object:self userInfo:orderQty ];
    [self.view removeFromSuperview];
    
    ////////
    ///////  Make sure Core Data setup matches that of AppDelegate
    NSMutableDictionary *orderInfo = [[NSMutableDictionary alloc] init];
    NSString *itemName = self.title;
    [orderInfo setObject:myNumber forKey:@"quantity"];
    [orderInfo setObject:itemName forKey:@"itemName"];
       
    ///////
    //////
}

-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
