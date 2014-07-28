//
//  SearchRestaurantsViewController.h
//  TakeOut
//
//  Created by Will Alvarez on 7/2/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SearchRestaurantsViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL firstLaunch;
}


@property (strong, nonatomic) IBOutlet MKMapView *mapView;
//property (strong, nonatomic) IBOutlet  *restoViewController;

@property (strong, nonatomic) NSString *restoname;
@property (strong, nonatomic) NSArray *restaurants;
-(NSArray*)restaurants;

@end
