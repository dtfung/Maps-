//
//  MapsViewController.m
//  week5Maps
//
//  Created by Aditya Narayan on 7/8/15.
//  Copyright (c) 2015 Aditya Narayan. All rights reserved.
//

#import "MapsViewController.h"
#import "MyPointAnnotation.h"

#define METERS_PER_MILE 1609.344


@interface MapsViewController () {
    NSString *url;
}
@end

@implementation MapsViewController
@synthesize mapView;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    locationManager = [[CLLocationManager alloc]init];
    [locationManager setDelegate:self];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    return self;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    self.mySearch.delegate = self;
    self.imageButton.image = [UIImage imageNamed:@"turn-to-tech-new-logo.jpg"];
    

    // Do any additional setup after loading the view, typically from a nib.
    mapView.showsUserLocation = NO;
    
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    
    //ZOOM IN ON TURN TO TECH!!!
    CLLocationCoordinate2D turnToTech;
    turnToTech.latitude = 40.741444;
    turnToTech.longitude= -73.99007;
    
    MKPointAnnotation *pinForTurnToTech = [[MKPointAnnotation alloc] init];
    pinForTurnToTech.coordinate = turnToTech;
    pinForTurnToTech.title = @"Turn To Tech";
    pinForTurnToTech.subtitle = @"New York, NY";
    
    //SOME RESTAURANTS I LIKE THAT ARE NEARBY
    CLLocationCoordinate2D mangia;
    mangia.latitude = 40.74174;
    mangia.longitude = -73.99064;
    
    MKPointAnnotation *pinForMangia = [[MKPointAnnotation alloc] init];
    pinForMangia.coordinate = mangia;
    pinForMangia.title = @"Mangia";
    pinForMangia.subtitle = @"Flatiron, NY 10010";
    
    CLLocationCoordinate2D juiceShop;
    juiceShop.latitude = 40.74202;
    juiceShop.longitude = -73.99342;
    
    MKPointAnnotation *pinForJuiceShop = [[MKPointAnnotation alloc] init];
    pinForJuiceShop.coordinate = juiceShop;
    pinForJuiceShop.title = @"The Juice Shop";
    pinForJuiceShop.subtitle = @"Flatiron, NY 10010";
    
    CLLocationCoordinate2D indiKitch;
    indiKitch.latitude = 40.74222;
    indiKitch.longitude = -73.99044;

    MKPointAnnotation *pinForIndiKitch = [[MKPointAnnotation alloc] init];
    pinForIndiKitch.coordinate = indiKitch;
    pinForIndiKitch.title = @"Indikitch";
    pinForIndiKitch.subtitle = @"Flatiron, NY, 10010";
    
    //add pins to the location array
    NSMutableArray *locations = [[NSMutableArray alloc]initWithObjects:pinForTurnToTech, pinForMangia, pinForJuiceShop, pinForIndiKitch, nil];

    // 2 sets radius of view to zoom in on
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(turnToTech, .1*METERS_PER_MILE, 0.1*METERS_PER_MILE);
    
    // 3 tells map view to display the region
    [mapView setRegion:viewRegion animated:YES];
    
    //[self.mapView addAnnotations:locations];
    
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    // Create and initialize a search request object which will contain parameters to search for.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    //A string containing the desired search item.
    request.naturalLanguageQuery = self.mySearch.text;
    // A Map region of where to search
    request.region = self.mapView.region;
    
    // Create and initialize a search object.
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    // Start the search and display the results as annotations on the map.
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error)
     {
         //an array to store annotations to be placed on Mapview
         NSMutableArray *annotationViews = [NSMutableArray array];
         //mapItems represents the search result.  Add it to an array.
         for (MKMapItem *item in response.mapItems) {

            MKPlacemark *pm = item.placemark;
                 
                 if(pm.title.length>0){

                     //an instance of the subclass of MyPointAnnotation.  Used to access or assign the url property containing a string to each annotation view.
                     MyPointAnnotation *annotation = [[MyPointAnnotation alloc] init];
                     annotation.coordinate = pm.coordinate;
                     annotation.title = pm.name;
                     annotation.subtitle = [item.url absoluteString];
                     annotation.url = [item.url absoluteString];
                     [annotationViews addObject:annotation];
                 }
         }
         
         [self.mapView removeAnnotations:[self.mapView annotations]];
         [self.mapView showAnnotations:annotationViews animated:NO];
  
     }];
}


//SETS IMAGE TO THE LEFT SIDE OF ANNOTATION & ADDS A BUTTON

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *view = nil;
    if (annotation != self.mapView.userLocation) {
        view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotationIdentifier"];
        if (!view) {
            // Creating a new annotation view, in this case it still looks like a pin
            view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotationIdentifier"];
            view.canShowCallout = YES; // So that the callout can appear
            
            //ADD BUTTON
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            view.rightCalloutAccessoryView = rightButton;
            
            //ADD IMAGE
            UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"marker.png"]];
            myImageView.frame = CGRectMake(0,0,31,31); // Change the size of the image to fit the callout
            view.leftCalloutAccessoryView = myImageView;
           
        }
    }
    return view;
}


////PUSH TO A NEXT VIEW CONTROLLER ON CLICKING AN ANNOTATION VIEW
- (void)mapView:(MKMapView *)mapView
 annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    //create an instance of the MKAnnotation protocol and set it equal to the annotation object that was clicked.
     id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MyPointAnnotation class]])
    
    {
        MyPointAnnotation *anot = annotation;
        self.webview = [[webviewViewController alloc] init];
        self.webview.webPages = anot.url;
        NSLog(@"webpages is %@", self.webview.webPages);
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.webview];
        navController.navigationBarHidden = NO;
        [self presentViewController:navController animated:YES completion:^{
            
        }];
        
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


    //ZOOMS IN ON USER LOCATION
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  
//          userLocation.location.coordinate.latitude,
//          userLocation.location.coordinate.longitude);
    
    
    //defines which portion of the map to display
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 250, 250);
    
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    // Add an annotation
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
////    point.coordinate = userLocation.coordinate;
////    point.title = @"Where am I?";
////    point.subtitle = @"I'm here!!!";
////    [self.mapView addAnnotation:point];
    [self.mapView setRegion:region animated:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
