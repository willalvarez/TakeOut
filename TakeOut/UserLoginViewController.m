//
//  UserLoginViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/8/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "UserLoginViewController.h"

@interface UserLoginViewController ()

@end

@implementation UserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}
@end
