//
//  MapsViewController.h
//  week5Maps
//
//  Created by Aditya Narayan on 7/8/15.
//  Copyright (c) 2015 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "webviewViewController.h"

@interface MapsViewController : UIViewController
<CLLocationManagerDelegate, MKMapViewDelegate, UISearchBarDelegate>
{
    CLLocationManager *locationManager;
}

@property(nonatomic,retain)IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *mySearch;

@property (strong, nonatomic) IBOutlet UIImageView *imageButton;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *subtitle;
@property(nonatomic,retain)webviewViewController *webview;


@end
