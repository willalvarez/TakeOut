//
//  RestaurantsViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/4/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/PFQueryTableViewController.h>

@interface RestaurantsViewController : PFQueryTableViewController
@property (strong, nonatomic) NSString *restoname;
@property (strong, nonatomic) NSArray *restonames;
@end
