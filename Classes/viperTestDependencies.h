//
// viperTestDependencies.h
//
// Copyright (c) 2014. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ChargingStationPresenter.h"

@interface viperTestDependencies : NSObject
{
    ChargingStationPresenter *chargingStationPresenter;
}

@property (nonatomic, strong) ChargingStationPresenter *chargingStationPresenter;


@end
