//
//  Menu.h
//  TakeOut
//
//  Created by Will Alvarez on 7/6/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Menu : NSManagedObject

@property (nonatomic, retain) NSString * restaurant;
@property (nonatomic, retain) NSString * item_category;
@property (nonatomic, retain) NSString * item_name;

@end
