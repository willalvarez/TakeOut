//
//  AmazonS3ViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/11/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "AmazonS3ViewController.h"
#import "Constants.h"

/////////
/////////
/*
 
 // Get Image
 UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
 imagePicker.delegate = self;
 [self presentModalViewController:imagePicker animated:YES];
 
 // Upload Image
    // step1 - create amazon S3 cient
    AmazonS3Client *s3 = [[[AmazonS3Client alloc] initWithAccessKey:MY_ACCESS_KEY_ID withSecretKey:MY_SECRET_KEY] autorelease];
    
   // Step 2 - create S3 bucket to store the picture
   [s3 createBucket:[[[S3CreateBucketRequest alloc] initWithName:MY_PICTURE_BUCKET] autorelease]];
 
   // Finally, put objects in S3
    S3PutObjectRequest *por = [[[S3PutObjectRequest alloc] initWithKey:MY_PICTURE_NAME inBucket:MY_PICTURE_BUCKET] autorelease];
    por.contentType = @"image/jpeg";
    por.data = imageData;
    [s3 putObject:por];
 */
/////////
/////////



@interface AmazonS3ViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation AmazonS3ViewController

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
    
    self.s3 = [[AmazonS3Util alloc] initWithAccessKey:ACCESS_KEY_ID secretKey:SECRET_KEY
                                               bucket:[Constants uploadBucket] delegate:self];
    
    [self loadData];
}

-(void)loadData
{
    tableData = [[self s3] listFromBucket:[Constants uploadBucket]];
   [tableView reloadData];
}

- (IBAction)edit:(id)sender{
    if([tableView isEditing]){
        [sender setTitle:@"Edit"];
    }
    else{
        [sender setTitle:@"Done"];
    }
    [tableView setEditing:![tableView isEditing]];
}

- (IBAction)takePicture:(id)sender{
    
    if([pop isPopoverVisible]){
        [pop dismissPopoverAnimated:YES];
        pop = nil;
        return;
    }
    
    UIImagePickerController *ip = [[UIImagePickerController alloc] init];
    
    if( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
        
        [ip setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [ip setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
    }
    
    [ip setAllowsEditing:TRUE];
    
    [ip setDelegate:self];
    
    pop = [[UIPopoverController alloc]initWithContentViewController:ip];
    
    [pop setDelegate:self];
    
    [pop presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [pop dismissPopoverAnimated:YES];
    pop = nil;
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [imageView setImage:image];
    
    NSData *imageData = UIImageJPEGRepresentation ( image, 1.0);
    
    
    NSString *fileName = [[NSString alloc] initWithFormat:@"%f.jpg", [[NSDate date] timeIntervalSince1970 ] ];
    
    [[self s3] uploadData:imageData format:@"image/jpeg"
               bucketName:[Constants uploadBucket] withKey:fileName];
    
    
}


//tableView Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"Table Data Count: %d", [tableData count]);
    return [tableData count];
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell){
        cell =
        [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSString *fileName = [[NSString alloc] initWithFormat:@"%@",
                          [tableData objectAtIndex: indexPath.row ]];
    
    [[cell textLabel] setText: fileName];
    return cell;
}


- (void)tableView: (UITableView *)tableView didSelectRowAtIndexPath: (NSIndexPath *)indexPath
{
    
    NSString *fileName = [NSString stringWithFormat:@"%@",
                          [tableData objectAtIndex: indexPath.row ]];
    
    NSData *downloadData = [[self s3] downloadFromBucket:[Constants uploadBucket] withKey:fileName];
    
    if(downloadData)imageView.image = [UIImage imageWithData:downloadData];
}


- (void) tableView: (UITableView *)tableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *fileName = [NSString stringWithFormat:@"%@",
                          [tableData objectAtIndex: indexPath.row ]];
    
    [[self s3] deleteFromBucket:[Constants uploadBucket] withKey:fileName];
    [self loadData];
}



@end
