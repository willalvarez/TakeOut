//
//  StripeEnrollmentViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/7/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "StripeEnrollmentViewController.h"
//Test Stripe Enrollment, Stripe Charges (move these to separate class..eventualy)
#import "Stripe.h"

#define clientID @"ca_4MPqWmoPVN8LDZ5Iy4btS8U1z9xreMfU"
#define clientSecret @"sk_test_hIFslJOcxD6SRUZOBBijNKdu"

@interface StripeEnrollmentViewController ()
{
    NSString *JSString;
    NSString *stripeURL;
    NSString *currentURL;
    NSString *stripetokenURL;
    NSString *redirectURL;
    NSString *client_access_token;
    NSString *stripe_publishable_key;
    NSString *authcode;
}
@property (strong, nonatomic) STPCard* stripeCard;
@end

@implementation StripeEnrollmentViewController
@synthesize webView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Stripe Connect";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        makingFirstRequest = TRUE;
        redirectURL = @"http://env1-j5h4ka9v5s.elasticbeanstalk.com/HelloWorld";
        stripeURL = @"https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_4MPqWmoPVN8LDZ5Iy4btS8U1z9xreMfU&scope=read_write&state=1234";
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *path;
    NSBundle *thisBundle = [NSBundle mainBundle];
    path = [thisBundle pathForResource:@"index" ofType:@"html"];
  
 //   [webView loadRequest:[NSURLRequest requestWithURL:instructionsURL]];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:stripeURL ]]];
  

}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Load the first request in place, because there is no web view currently showing
    if (makingFirstRequest) {
      //  makingFirstRequest = NO;
        NSLog(@"First load..happening");
        
       return YES;
    }
    

  //  NSLog(@"Button was Touched!!");
    return YES;
         }

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"I'm finished loading a webView");
  if (!makingFirstRequest)
    {
        NSString * jsCallBack = [NSString stringWithFormat:@"myFunction()"];
        [self.webView stringByEvaluatingJavaScriptFromString:jsCallBack];
        
        //////
        ////// Coming back from Stripe, get the authorization code
      currentURL = self.webView.request.URL.absoluteString;
     //   currentURL = @"http://env1-j5h4ka9v5s.elasticbeanstalk.com/HelloWorld?state=1234&scope=read_write&code=ac_4R9hLhUQBIvL4YpdxFVjnMG52XQm2iHC";
        
        NSMutableDictionary *queryStringDictionary = [[NSMutableDictionary alloc] init];
        NSArray *urlComponents = [currentURL componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [pairComponents objectAtIndex:0];
            NSString *value = [pairComponents objectAtIndex:1];
            
            [queryStringDictionary setObject:value forKey:key];
        }
        
        authcode = [queryStringDictionary objectForKey:@"code"];
        NSString *access_token = [queryStringDictionary objectForKey:@"access_token"];
        NSLog(@"Stripe auth code: %@", authcode);
        
        // Make a POST to Stripe Connec with the authcode
        if (authcode!=nil){
        
        
              /*
               curl -X POST https://connect.stripe.com/oauth/token \
               -d client_secret=sk_test_hIFslJOcxD6SRUZOBBijNKdu \
               -d code=AUTHORIZATION_CODE \
               -d grant_type=authorization_code
               */
            NSLog(@"authcode:%@",authcode);
                stripetokenURL = @"https://connect.stripe.com/oauth/token?client_secret=sk_test_hIFslJOcxD6SRUZOBBijNKdu&code=";
            stripetokenURL  = [stripetokenURL stringByAppendingString:authcode];
            stripetokenURL = [stripetokenURL stringByAppendingString:@"&grant_type=authorization_code"];
            
            NSLog(@"Problem staring me in the eye, code='authcode'...look!! %@", stripetokenURL);
            // Create the request.
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stripetokenURL]];

            // Specify that it will be a POST request
            request.HTTPMethod = @"POST";
            // Create url connection and fire request
            NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            
            [conn scheduleInRunLoop:[NSRunLoop mainRunLoop]
                            forMode:NSDefaultRunLoopMode];
            [conn start];
            
            // Check if connection is successful
            if (conn)
            {
                NSLog(@"Connection succeeded");
                currentURL = self.webView.request.URL.absoluteString;
                // get access_code
            }
            if (!conn)
                NSLog(@"Connection Failed");

        }
        //////
        //////
    } else {
        makingFirstRequest = NO;
        
    }
}


#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
        NSString *jsonString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSLog(@"JSON: %@", jsonString);
    NSDictionary* jsonStatus = [NSJSONSerialization
                                JSONObjectWithData:responseData //1
                                
                                options:kNilOptions
                                error:&error];
    NSString *jsonString2 = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSLog(@"JSON-to-String from NSDictionary: %@", jsonString2);
    
    client_access_token = [jsonStatus objectForKey:@"access_token"];
    stripe_publishable_key = [jsonStatus objectForKey:@"stripe_publishable_key"];
    NSLog(@"Success!! I can charge for restaurants now:%@", client_access_token);
    NSLog(@"Use Client Publishable key to make charges on their behalf:%@", stripe_publishable_key);
    /*
    //Now make a charge on behalf of Client (access_token: sk_test_4TUvfIVM8dCa0cKGpuz1ZfTa)
    //1
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = @"Will Alvarez";
    self.stripeCard.number = @"4242424242424242";
    self.stripeCard.cvc = @"123";
    self.stripeCard.expMonth = 12;
    self.stripeCard.expYear = 2014;
    
    //2
    if ([self validateCustomerInfo]) {
        [self performStripeOperation];
    } else {
        self.completeButton.enabled = YES;
    }

    */
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSLog(@"Connection Failed:%@", error);
}


@end
