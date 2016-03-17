//
// ChargingStationPresenter.m
//
// Copyright (c) 2014

#import "ChargingStationPresenter.h"
#import "UserSessionInfo.h"

@implementation ChargingStationPresenter


- (void)downloadUpdatedStationDB:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    [self.stationManager downloadUpdatedStationDB:^(NSMutableArray *stationList, NSError *error) {
        if (error == nil)
        {
            completionHandler(stationList, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

- (void) getAllStations:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    [self.stationManager getAllStations:^(NSMutableArray *stationList, NSError *error) {
        if (error == nil)
        {
            completionHandler(stationList, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}


- (void)getStationMarkersNearCordinate:(CLLocationCoordinate2D)coordinates
                      completion:(void (^)(NSMutableArray *stationMarkerList, NSError *error))completionHandler
{
    [self.stationManager getStationsNearCordinate:coordinates completion:^(NSMutableArray *stationList, NSError *error) {
        if (error == nil)
        {
            NSMutableArray *markers = [[NSMutableArray alloc] init];
            UserSessionInfo *userSession = [UserSessionInfo sharedUser];
            
            for (ChargingStation *station in stationList)
            {
                NSString *stationType = station.type;
                if ([userSession.displayStationTypes containsObject:stationType])
                {
                    ChargingMarker *marker = [ChargingMarker alloc];
                    marker = [marker initWithStation:station];

                    [markers addObject:marker];
                }
            }
            
            completionHandler(markers, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

@end
