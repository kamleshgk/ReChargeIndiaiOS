//
// ChargingStationManager.h
//
// Copyright (c) 2014. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ChargingStation.h"
@import CoreLocation;
@import Firebase;

@interface ChargingStationManager : NSObject
{
    
}

- (void)downloadUpdatedStationDB:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getAllStations:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getStationsNearCordinate:(CLLocationCoordinate2D)coordinates
                            completion:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getAllCommentsForStationId:(NSString *)stationId
                        completion:(void (^)(NSMutableArray *commentList, NSError *error))completionHandler;


@end
