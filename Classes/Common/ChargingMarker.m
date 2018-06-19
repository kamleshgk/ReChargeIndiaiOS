//
// ChargingMarker.m
//
// Copyright (c) 2014. All rights reserved.

#import "ChargingMarker.h"
#import "UserSessionInfo.h"

@implementation ChargingMarker

@synthesize stationDetails;

- (id) initWithStation: (ChargingStation *) station {
    if ( self = [super init] ) {
        // Set defaults
    }
    
    self.stationDetails = station;
    
    self.position = CLLocationCoordinate2DMake([stationDetails.lattitude floatValue], [stationDetails.longitude floatValue]);
    self.title = stationDetails.name;
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *userLatitude = [[NSNumber numberWithDouble:userSession.currentUserLocation.latitude] stringValue];
    NSString *userLongitude = [[NSNumber numberWithDouble:userSession.currentUserLocation.longitude] stringValue];
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:[userLatitude floatValue]
                                                          longitude:[userLongitude floatValue]];
    
    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:[station.lattitude floatValue] longitude:[station.longitude floatValue]];
        
    CLLocationDistance meters = [stationLocation distanceFromLocation:userLocation];
    
    NSString *typeText = [NSString alloc];
    if ([stationDetails.type isEqualToString:@"1"])
        typeText = @"Community Charge Point (Business)";
    else if ([stationDetails.type isEqualToString:@"2"])
        typeText = @"Mahindra Electric Charge Point";
    else if ([stationDetails.type isEqualToString:@"3"])
        typeText = @"Ather Grid Charge Pod";
    else if ([stationDetails.type isEqualToString:@"4"])
        typeText = @"Community Charge Point (Residence)";
    else if ([stationDetails.type isEqualToString:@"5"])
        typeText = @"DC Quick Charge Station";
    else if ([stationDetails.type isEqualToString:@"6"])
        typeText = @"Sun Mobility Battery Swap Station";
    
    NSString *snippetString = [NSString stringWithFormat:@"Tap to view details >> \n\nDistance from you: %.02f km\nType: %@", (meters/1000),typeText];//stationDetails.notes];
    
    self.snippet = snippetString;
    
    if ([stationDetails.type isEqualToString:@"1"])
        self.icon = [UIImage imageNamed:@"communityBus"];
    else if ([stationDetails.type isEqualToString:@"2"])
        self.icon = [UIImage imageNamed:@"mahindra"];
    else if ([stationDetails.type isEqualToString:@"3"])
        self.icon = [UIImage imageNamed:@"ather"];
    else if ([stationDetails.type isEqualToString:@"4"])
        self.icon = [UIImage imageNamed:@"communityHome"];
    else if ([stationDetails.type isEqualToString:@"5"])
        self.icon = [UIImage imageNamed:@"fastCharger"];
    else if ([stationDetails.type isEqualToString:@"6"])
        self.icon = [UIImage imageNamed:@"sun"];
    
    self.groundAnchor = CGPointMake(0.5, 1);
    self.appearAnimation = kGMSMarkerAnimationPop;
    
    return self;
}

@end
