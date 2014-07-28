//
//  OrderItemViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/3/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetail.h"
#import "OrderHeader.h"
#import <CoreData/CoreData.h>

@interface OrderItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *specialInstructions;
@property (weak, nonatomic) IBOutlet UILabel *labelItem;
@property (copy) NSNumber *runningQty;

@property (weak, nonatomic) IBOutlet UITextField *itemQuantity;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@end
