
//
//
// Copyright (c) 2014. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import "LeftPanelViewController.h"
#import "ChargingStationPresenter.h"
#import "SettingsViewController.h"
#import "LocationSearchTable.h"
@import CoreLocation;
@import GoogleMaps;

@class SWRevealViewController;


@interface HomeViewController : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, SettingsViewDelegate,
                                                 SearchResultsDelegate>
{
    IBOutlet UIButton *searchButton;
    
    ChargingStationPresenter *presentor;
    
    GMSMapView *mapView;
    
    IBOutlet UIView *searchTextView;
    
    CLLocationManager *locationManager;
    
    BOOL firstLocationUpdate;
    BOOL fUserTapMyLocationButton;
}

@property IBOutlet GMSMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) IBOutlet UIButton *sideMenuButton;  //Need this for left nav

@property (strong, nonatomic) UISearchController *searchController;

@end
