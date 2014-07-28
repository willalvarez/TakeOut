//
//  OrderDetail.h
//  TakeOut
//
//  Created by Will Alvarez on 7/4/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface OrderDetail : NSManagedObject

@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSDecimalNumber * itemQty;
@property (nonatomic, retain) NSNumber * orderNumber;

@end
