//
//  SearchRestaurantsViewController.m
//  TakeOut
//
//  Created by Will Alvarez on 7/2/14.
//  Copyright (c) 2014 Will Alvarez. All rights reserved.
//

#import "SearchRestaurantsViewController.h"
#import "MapPoint.h"

@interface SearchRestaurantsViewController ()
{
    __weak IBOutlet UISegmentedControl *placesSegmentedControl;
    MKPinAnnotationView *mypin;
    __weak IBOutlet UISearchBar *searchBar;
}

@end

@implementation SearchRestaurantsViewController

#define kGOOGLE_API_KEY @"AIzaSyDhHAl2tM55agl4gzNAj1auItykQR9eMzw"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@synthesize mapView;
@synthesize restoname;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.title = NSLocalizedString(@"TakeOut", @"TakeOut");
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    //Make this controller the delegate for the map view.
    self.mapView.delegate = self;
    
    // Ensure that we can view our own location in the map view.
    [self.mapView setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some paramater for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    //Set the first launch instance variable to allow the map to zoom on the user location when first launched.
    firstLaunch=YES;
    
    
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)selectPlaces:(id)sender {
    //Call it like this
    
    NSString *buttonTitle = [self getTitleForSelectedSegment:placesSegmentedControl];
    NSString *googleType = [buttonTitle lowercaseString];
    
    //Use this title text to build the URL query and get the data from Google. Change the radius value to increase the size of the search area in meters. The max is 50,000.
    [self queryGooglePlaces:googleType];
    
    
}

-(void) queryGooglePlaces: (NSString *) googleType
{
    
    
    // Build the url string we are going to sent to Google. NOTE: The kGOOGLE_API_KEY is a constant which should contain your own API key that you can obtain from Google. See this link for more info:
    // https://developers.google.com/maps/documentation/places/#Authentication
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%@&types=%@&sensor=true&key=%@", currentCentre.latitude, currentCentre.longitude, [NSString stringWithFormat:@"%i", currenDist], googleType, kGOOGLE_API_KEY];
    
    //Formulate the string as URL object.
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    // Retrieve the results of the URL.
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}

- (void)fetchedData:(NSData *)responseData {
    //parse out the json data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          
                          options:kNilOptions
                          error:&error];
    
    //The results from Google will be an array obtained from the NSDictionary object with the key "results".
    NSArray* places = [json objectForKey:@"results"];
    
    //Write out the data to the console.
    NSLog(@"Google Data: %@", places);
    
    //Plot the data in the places array onto the map with the plotPostions method.
    [self plotPositions:places];
    
    
}

- (void)plotPositions:(NSArray *)data
{
    //Remove any existing custom annotations but not the user location blue dot.
    for (id<MKAnnotation> annotation in mapView.annotations)
    {
        if ([annotation isKindOfClass:[MapPoint class]])
        {
            [mapView removeAnnotation:annotation];
        }
    }
    
    
    //Loop through the array of places returned from the Google API.
    for (int i=0; i<[data count]; i++)
    {
        
        //Retrieve the NSDictionary object in each index of the array.
        NSDictionary* place = [data objectAtIndex:i];
        
        //There is a specific NSDictionary object that gives us location info.
        NSDictionary *geo = [place objectForKey:@"geometry"];
        
        
        //Get our name and address info for adding to a pin.
        NSString *name=[place objectForKey:@"name"];
        NSString *vicinity=[place objectForKey:@"vicinity"];
        
        //Get the lat and long for the location.
        NSDictionary *loc = [geo objectForKey:@"location"];
        
        //Create a special variable to hold this coordinate info.
        CLLocationCoordinate2D placeCoord;
        
        //Set the lat and long.
        placeCoord.latitude=[[loc objectForKey:@"lat"] doubleValue];
        placeCoord.longitude=[[loc objectForKey:@"lng"] doubleValue];
        
        //Create a new annotiation.
        MapPoint *placeObject = [[MapPoint alloc] initWithName:name address:vicinity coordinate:placeCoord];
        
        
        [mapView addAnnotation:placeObject];
    }
}

-(IBAction)setMap:(id)sender
{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}



- (NSString *) getTitleForSelectedSegment: (UISegmentedControl *) segment {
    return [segment titleForSegmentAtIndex:[segment selectedSegmentIndex]];
}


#pragma mark - MKMapViewDelegate methods.


- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
{
    
    //Zoom back to the user location after adding a new set of annotations.
    
    //Get the center point of the visible map.
    CLLocationCoordinate2D centre = [mv centerCoordinate];
    
    MKCoordinateRegion region;
    
    //If this is the first launch of the app then set the center point of the map to the user's location.
    if (firstLaunch) {
        // region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        region = MKCoordinateRegionMakeWithDistance(locationManager.location.coordinate,1000,1000);
        firstLaunch=NO;
    }else {
        //Set the center point to the visible region of the map and change the radius to match the search radius passed to the Google query string.
        region = MKCoordinateRegionMakeWithDistance(centre,currenDist,currenDist);
    }
    
    //Set the visible region of the map.
    [mv setRegion:region animated:YES];
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    ////////
    ////////
    
    mypin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"current"];
    mypin.pinColor = MKPinAnnotationColorPurple;
    mypin.backgroundColor = [UIColor clearColor];
    //   UIButton *goToDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIButton *goToDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    mypin.rightCalloutAccessoryView = goToDetail;
    mypin.draggable = NO;
    mypin.highlighted = YES;
    mypin.animatesDrop = TRUE;
    mypin.canShowCallout = YES;
    
    ///////
    ///////
    
    //Define our reuse indentifier.
    static NSString *identifier = @"MapPoint";
    
    
    if ([annotation isKindOfClass:[MapPoint class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.backgroundColor = [UIColor clearColor];
        annotationView.rightCalloutAccessoryView = goToDetail;
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{

    
    MapPoint   *annView = [mapView.selectedAnnotations objectAtIndex:0];
 
    self.restoname = annView.name;

    
    NSString *notificaiton_restoname = self.restoname;
     NSDictionary *extraInfo = [NSDictionary dictionaryWithObject:self.restoname forKey:@"resto_name"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searched_resto" object:self userInfo:extraInfo ];
    [self.tabBarController setSelectedIndex:1];
}


- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    
    //Get the east and west points on the map so we calculate the distance (zoom level) of the current map view.
    MKMapRect mRect = self.mapView.visibleMapRect;
    MKMapPoint eastMapPoint = MKMapPointMake(MKMapRectGetMinX(mRect), MKMapRectGetMidY(mRect));
    MKMapPoint westMapPoint = MKMapPointMake(MKMapRectGetMaxX(mRect), MKMapRectGetMidY(mRect));
    
    //Set our current distance instance variable.
    currenDist = MKMetersBetweenMapPoints(eastMapPoint, westMapPoint);
    
    //Set our current centre point on the map instance variable.
    currentCentre = self.mapView.centerCoordinate;
}


-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"Location: %f, %f",
          userLocation.location.coordinate.latitude,
          userLocation.location.coordinate.longitude);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    [self.mapView setRegion:region animated:YES];
}


@end
