
//
//
// Copyright (c) 2014. All rights reserved.
//


#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "SVProgressHud.h"
#import "UserSessionInfo.h"
#import "Utils.h"
#import "ChargingMarker.h"
#import "LocationSearchTable.h"
#import "ChargingStationDetailsViewController.h"

@interface HomeViewController () <SWRevealViewControllerDelegate, ChargingStationDetailsDelegate> {
    
}
@end

@implementation HomeViewController

@synthesize mapView, locationManager;

#pragma mark - UIView Management Functions

// Set things up on load
- (void)viewDidLoad {

    NSLog(@"Debug entering viewDidLoad");
    
    [self addSideMenuAction];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    
    firstLocationUpdate = NO;
    
    fUserTapMyLocationButton = NO;
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    presentor = userSession.dependencies.chargingStationPresenter;
    
    
    // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case
    
    LocationSearchTable *locationSearchTable = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationSearchTable"];
    locationSearchTable.delegate = self;
    
    // Init UISearchController with the search results controller
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:locationSearchTable];
    
    // Link the search controller
    self.searchController.searchResultsUpdater = locationSearchTable;
    
    // This is obviously needed because the search bar will be contained in the navigation bar
    self.searchController.hidesNavigationBarDuringPresentation = YES;
    
    // Required (?) to set place a search bar in a navigation bar
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleDefault;
    self.searchController.searchBar.translucent = YES;
    
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = @"Search Chargers";
    [self.searchController.searchBar setFrame:CGRectMake(0, 0, 200, 45)];
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:19.0/255.0 green:36.0/255.0 blue:184.0/255.0 alpha:1];
    // This is where you set the search bar in the navigation bar, instead of using table view's header ...
    [searchTextView addSubview:self.searchController.searchBar];
    
    // To ensure search results controller is presented in the current view controller
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    self.searchController.delegate = locationSearchTable;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = locationSearchTable;
    
    // Load data
    [self f_load];
    
    
    mapView.delegate = self;
    
    NSLog(@"Debug f_load is complete");
    
	[super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationController *nav = self.navigationController;
    [nav setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc
{

}


#pragma mark - SettingsDelegate
-(void)dropPinZoomIn:(ChargingStation *)station
{
    NSLog(@"Time to show data for station %@", station.name);
    
    CLLocationCoordinate2D target =
        CLLocationCoordinate2DMake([station.lattitude floatValue], [station.longitude floatValue]);
    
    [self addMarkersNearLocation:target];
    
    mapView.camera = [GMSCameraPosition cameraWithTarget:target
                                                    zoom:16 bearing:0 viewingAngle:0];
    
    [mapView animateToLocation:target];
    [mapView animateToZoom:16];
}


#pragma mark - SearchDelegate
-(void)doneSelected
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self addMarkersNearLocation:mapView.camera.target];
}


#pragma mark - Charging Station Details
-(void)doneSelectedDetails
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Google Maps Methods

- (BOOL) didTapMyLocationButtonForMapView:(GMSMapView *) mapView1
{
    fUserTapMyLocationButton = YES;
    self.searchController.searchBar.text = @"";
    return NO;
}

- (void)mapView:(GMSMapView *)mapView1 idleAtCameraPosition:(GMSCameraPosition *)position
{
    if (fUserTapMyLocationButton == YES)
    {
        NSLog(@"Triggered! %f, %f", mapView1.camera.target.latitude, mapView1.camera.target.longitude);
        
        fUserTapMyLocationButton = NO;
        
        //kamlesh - Hack as sometimes GMAP SDK does not render markers when location button is tapped
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self addMarkersNearLocation:mapView1.camera.target];
        });
    }
    else
    {
        if (position.zoom <= 6)
        {
            //Show all India stations
            NSMutableArray *markers = [[NSMutableArray alloc] init];
            UserSessionInfo *userSession = [UserSessionInfo sharedUser];
            
            for (ChargingStation *station in userSession.stationsCache)
            {
                ChargingMarker *marker = [ChargingMarker alloc];
                marker = [marker initWithStation:station];
                
                [markers addObject:marker];
            }
            
            [self addAllMarkers:markers];
        }
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    ChargingMarker *chargingMarker = (ChargingMarker *)marker;
    
    [self performSegueWithIdentifier:@"Types SegueDetail" sender:chargingMarker];
    
}


#pragma mark - Location Manager Delegate Methods

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        //location denied, handle accordingly
    }
    else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        //hooray! begin startTracking
        
        [self.locationManager startUpdatingLocation];
        
        mapView.myLocationEnabled = YES;
        mapView.settings.myLocationButton = YES;
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (firstLocationUpdate == NO)
    {
        CLLocation *location = [locations lastObject];

        CLLocationDegrees lat = location.coordinate.latitude;
        CLLocationDegrees longi = location.coordinate.longitude;

        CLLocationCoordinate2D target =
        CLLocationCoordinate2DMake(lat, longi);

        mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                        zoom:12 bearing:0 viewingAngle:0];

        UserSessionInfo *userSession = [UserSessionInfo sharedUser];
        userSession.currentUserLocation =target;
        
        [mapView animateToLocation:target];
        [mapView animateToZoom:12];

        [self.locationManager stopUpdatingLocation];

        [self addMarkersNearLocation:target];
        
        firstLocationUpdate = YES;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //self.locationLabel.text = error.localizedDescription;
}


#pragma mark - IBButton Handlers


- (IBAction)SearchData:(id)sender {
    
}

#pragma mark - Private Methods

-(void) addAllMarkers:(NSMutableArray *)markerList
{
    [mapView clear];
    
    for (ChargingMarker *marker in markerList) {
        marker.map = self.mapView;
    }
}

-(void) addMarkersNearLocation:(CLLocationCoordinate2D) location
{
    [mapView clear];
    
    [presentor getStationMarkersNearCordinate:location completion:^(NSMutableArray *stationMarkerList, NSError *error) {

        for (ChargingMarker *marker in stationMarkerList) {
            marker.map = self.mapView;
        }
        
    }];
}

-(void) addSideMenuAction {
    SWRevealViewController *parentRevealController = self.revealViewController;
    if (parentRevealController)
    {
        CGRect rect = self.view.bounds;
        
        parentRevealController.rearViewRevealWidth = rect.size.width * 0.8;
        [self.sideMenuButton addTarget:parentRevealController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addGestureRecognizer:parentRevealController.panGestureRecognizer];
    }
}

- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    //Do Stuff
    //[searchTextField resignFirstResponder];
}

- (void)f_load {
    
    NSLog(@"Debug running f_load");
    
    [SVProgressHUD showWithStatus:@"Loading Stations..."];
    
    [presentor getAllStations:^(NSMutableArray *stationList, NSError *error) {
        
        if (error == nil)
        {
            NSLog(@"Got STUFF");
            UserSessionInfo *userSession = [UserSessionInfo sharedUser];
            userSession.stationsCache = stationList;
            [SVProgressHUD dismiss];            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"The database seems to be corrupt.  Please try updating the database or reinstalling the app."];
        }
    }];

    NSLog(@"Debug out of f_load");
}

#pragma mark -
#pragma mark Seque stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Types Segue"])
    {
        UINavigationController *navVC = (UINavigationController *) segue.destinationViewController;
        SettingsViewController *detailVC = (SettingsViewController *) navVC.topViewController;
        detailVC.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"Types SegueDetail"])
    {
        ChargingMarker *chargingMarker = (ChargingMarker *)sender;
        
        UINavigationController *navVC = (UINavigationController *) segue.destinationViewController;
        ChargingStationDetailsViewController *detailVC = (ChargingStationDetailsViewController *) navVC.topViewController;
        detailVC.station = chargingMarker.stationDetails;
        detailVC.delegate = self;
    }
}



@end
