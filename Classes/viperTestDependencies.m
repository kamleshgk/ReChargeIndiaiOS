//
// viperTestDependencies.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "viperTestDependencies.h"

#import "ChargingStationManager.h"

@implementation viperTestDependencies

@synthesize chargingStationPresenter;

- (id)init
{
    if ((self = [super init]))
    {
        [self configureDependencies];
    }
    
    return self;
}

- (void)configureDependencies
{
    // Registration Modules Classes
    
    ChargingStationPresenter *presenterObject = [[ChargingStationPresenter alloc] init];
    ChargingStationManager *dataManager = [[ChargingStationManager alloc] init];
    
    presenterObject.stationManager = dataManager;
    self.chargingStationPresenter = presenterObject;
}

@end
