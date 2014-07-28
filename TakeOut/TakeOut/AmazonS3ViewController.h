//
//  AmazonS3ViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/11/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AmazonS3Util.h"

@interface AmazonS3ViewController : UIViewController {
    NSString *urlStr;
    UIPopoverController *pop;
    __weak IBOutlet UIImageView *imageView;

    __weak IBOutlet UITableView *tableView;
    NSArray *tableData;
}

@property (nonatomic, retain) AmazonS3Util *s3;

-(void)loadData;
- (IBAction)takePicture:(id)sender;
- (IBAction)edit:(id)sender;

@end
