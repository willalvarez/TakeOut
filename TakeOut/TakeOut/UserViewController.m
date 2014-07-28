//
//  UserViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/9/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "UserViewController.h"


#include <JavaScriptCore/JavaScript.h>
@interface UserViewController ()

@end

@implementation UserViewController
@synthesize name;
@synthesize phone;
@synthesize address;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Users";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)addUser:(id)sender {
    NSString *newname = name.text;
    NSString *newphone = phone.text;
    NSString *newaddress = address.text;
    User  *newuser = [User userWithName:newname phone:newphone address:newaddress];

    
    if(newuser==nil)
    {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Invalid Phone#"
                                                     message:@"Should be 10 digits"
                                                    delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
    [alert show];
    }
    
    else
    {
      NSLog(@"%@, your phone #:%@ is valid", newuser.name, newuser.phone);
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Valid Phone#"
                                                         message:@"Call me tonigh"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [alert show];
 
    }
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

@end
