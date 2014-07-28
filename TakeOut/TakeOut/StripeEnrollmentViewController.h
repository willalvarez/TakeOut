//
//  StripeEnrollmentViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/7/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StripeEnrollmentViewController : UIViewController <UIWebViewDelegate,NSURLConnectionDelegate>
{
         BOOL makingFirstRequest;
     IBOutlet UIWebView *webView;
     NSMutableData *responseData;
}
@property (nonatomic, retain) UIWebView *webView;

@end
