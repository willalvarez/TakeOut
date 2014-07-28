//
//  UserLoginViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/8/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLoginViewController : UIViewController
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *phone;
@property (nonatomic, readonly) NSString *address;

+ (instancetype)contactWithName:(NSString *)name
                          phone:(NSString *)phone
                        address:(NSString *)address;
@end
