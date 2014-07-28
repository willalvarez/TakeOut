//
//  OrderHeader.h
//  TakeOut
//
//  Created by Will Alvarez on 7/4/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface OrderHeader : NSManagedObject

@property (nonatomic, retain) NSString * orderAddress;
@property (nonatomic, retain) NSNumber * orderBuyer;
@property (nonatomic, retain) NSDate * orderDate;
@property (nonatomic, retain) NSNumber * orderNumber;
@property (nonatomic, retain) NSNumber * orderSeller;
@property (nonatomic, retain) NSString * orderPhone;
@property (nonatomic, retain) NSString * orderStatus;
@property (nonatomic, retain) NSDecimalNumber * orderTax;
@property (nonatomic, retain) NSDecimalNumber * orderTotalAmount;
@property (nonatomic, retain) NSNumber * numberOfItems;

@end
