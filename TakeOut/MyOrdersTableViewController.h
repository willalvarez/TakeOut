//
//  MyOrdersTableViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/4/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"

@interface MyOrdersTableViewController :UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) UITableView *tableView;

@property (strong, nonatomic) NSNumber *totalQtys;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSMutableArray *currentItems;
-(void)createTableView;
@end
