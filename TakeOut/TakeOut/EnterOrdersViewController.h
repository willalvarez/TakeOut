//
//  EnterOrdersViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/2/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItemViewController.h"
#import "MyOrdersTableViewController.h"

@interface EnterOrdersViewController : UIViewController
@property (nonatomic,retain) UILabel *TakeOutlogo;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIButton *done;
@property (nonatomic,retain) UIButton *buttonAppetizers;
@property (nonatomic,retain) UIButton *buttonCorner;
@property (nonatomic,retain) UIButton *buttonEntrees;
@property (nonatomic, retain) NSString *restoname;
@property (nonatomic,retain) UISegmentedControl *sgctrl;
@property (nonatomic,retain) UIImageView *imgView;
@property (nonatomic,retain) UIScrollView *itemScrollView;
@property (nonatomic, retain) OrderItemViewController *orderItemViewController;


-(void)createLogo;
-(void)createTableView;
-(void)createmenuButtons;

-(void)createsegment;
-(void)createImageView;

@end
