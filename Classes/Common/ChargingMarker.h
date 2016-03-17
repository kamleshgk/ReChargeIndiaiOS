//
// ChargingMarker.h
//
// Copyright (c) 2016. All rights reserved.

#import <Foundation/Foundation.h>
#import "ChargingStation.h"
@import GoogleMaps;

@interface ChargingMarker : GMSMarker
{
    ChargingStation *stationDetails;
}

@property (nonatomic, retain) ChargingStation *stationDetails;

- (id) initWithStation: (ChargingStation *) station;

@end

