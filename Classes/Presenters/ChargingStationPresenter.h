//
// ChargingStationPresenter.h
//
// Copyright (c) 2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChargingStationManager.h"
#import "ChargingStation.h"
#import "ChargingMarker.h"

@interface ChargingStationPresenter : NSObject

@property (nonatomic, strong) ChargingStationManager *stationManager;


- (void)downloadUpdatedStationDB:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void) getAllStations:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getStationMarkersNearCordinate:(CLLocationCoordinate2D)coordinates
                            completion:(void (^)(NSMutableArray *stationMarkerList, NSError *error))completionHandler;

@end
