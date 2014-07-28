//
//  AppDelegate.m
//  TakeOut
//
//  Created by Will Alvarez on 7/4/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "EnterOrdersViewController.h"
#import "OrdersQueueViewController.h"
#import "MyOrdersTableViewController.h"
#import "OrderItemViewController.h"
#import "RestaurantsViewController.h"
#import "MoreTableViewController.h"
#import "StripeEnrollmentViewController.h"
#import "OrderDetail.h"
#import "OrderHeader.h"
#import "UserViewController.h"
#import "Flurry.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Flurry Analytics
    //note: iOS only allows one crash reporting tool per app; if using another, set to: NO
    [Flurry setCrashReportingEnabled:YES];
    
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:@"VBPDBFSKNGJSVMYTRQRP"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    RestaurantsViewController *viewController1 = [[RestaurantsViewController alloc] init];
    UIViewController *viewController2 = [[EnterOrdersViewController alloc] initWithNibName:@"EnterOrdersViewController" bundle:nil];
    OrdersQueueViewController *viewController3 = [[OrdersQueueViewController alloc] init];
    MyOrdersTableViewController *viewController4 = [[MyOrdersTableViewController alloc] initWithNibName:@"MyOrdersTableViewController" bundle:nil];
    
    MoreTableViewController *moreViewController = [[MoreTableViewController alloc] initWithNibName:@"MoreTableViewController" bundle:nil];

    UINavigationController *navcntrl1    = [[UINavigationController alloc] initWithRootViewController:viewController1];
    UINavigationController *navcntrl2    = [[UINavigationController alloc] initWithRootViewController:viewController2];
    UINavigationController *navcntrl3    = [[UINavigationController alloc] initWithRootViewController:viewController3];
    UINavigationController *navcntrl4   = [[UINavigationController alloc] initWithRootViewController:viewController4];
    UINavigationController *morecntrl   = [[UINavigationController alloc] initWithRootViewController:moreViewController];
    
 //   UINavigationController *navcntrl5   = [[UINavigationController alloc] initWithRootViewController:viewController5];

    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navcntrl1, navcntrl2,navcntrl3,navcntrl4,morecntrl];
    self.window.rootViewController = self.tabBarController;
      
    // Register Parse Application.
    
	[Parse setApplicationId:@"ZJz3v8nIX70cNXyLZIgtTrvjG1j3Cd7QwXnShAOb"
                  clientKey:@"jTadDiS7V2zoukaNeK2cZVNm22seFdl2paP57Tyb"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
      viewController4.managedObjectContext = self.managedObjectContext;
    [self monitorOrders];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

-(void)monitorOrders
{

    [NSTimer scheduledTimerWithTimeInterval:900.0f
                                     target:self selector:@selector(newOrders:) userInfo:nil repeats:YES];
 
}


- (void) newOrders:(NSTimer *)timer
{

    PFQuery *query = [PFQuery queryWithClassName:@"OrderDetail"];
    [query countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        NSString *string = @(count).stringValue;
        NSDictionary *extraInfo = [NSDictionary dictionaryWithObject:string forKey:@"new_orders"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"neworders" object:self userInfo:extraInfo ];
    }];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TakeOut" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TakeOut.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}







@end
