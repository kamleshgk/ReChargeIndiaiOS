//
// ChargingMarker.m
//
// Copyright (c) 2014. All rights reserved.

#import "ChargingMarker.h"

@implementation ChargingMarker

@synthesize stationDetails;

- (id) initWithStation: (ChargingStation *) station {
    if ( self = [super init] ) {
        // Set defaults
    }
    
    self.stationDetails = station;
    
    self.position = CLLocationCoordinate2DMake([stationDetails.lattitude floatValue], [stationDetails.longitude floatValue]);
    self.title = stationDetails.name;
    
    NSString *snippetString = [NSString stringWithFormat:@"Tap to view details >> \n\n%@", stationDetails.notes];
    
    self.snippet = snippetString;
    
    if ([stationDetails.type isEqualToString:@"1"])
        self.icon = [UIImage imageNamed:@"green"];
    else if ([stationDetails.type isEqualToString:@"2"])
        self.icon = [UIImage imageNamed:@"red"];
    else if ([stationDetails.type isEqualToString:@"3"])
        self.icon = [UIImage imageNamed:@"blue"];
    
    self.groundAnchor = CGPointMake(0.5, 1);
    self.appearAnimation = kGMSMarkerAnimationPop;
    
    return self;
}

@end
