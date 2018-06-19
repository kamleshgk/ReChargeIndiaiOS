//
// ChargingStationPresenter.m
//
// Copyright (c) 2014

#import "ChargingStationPresenter.h"
#import "UserSessionInfo.h"

@implementation ChargingStationPresenter


- (void)doesLocalDBNeedUpdate:(void (^)(BOOL serverDBChanged, NSError *error))completionHandler
{
    [self.stationManager doesLocalDBNeedUpdate:^(BOOL serverDBChanged, NSError *error) {
        if (error == nil)
        {
            completionHandler(serverDBChanged, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

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


- (void)getAllCommentsForStationId:(NSString *)stationId
                        completion:(void (^)(NSMutableArray *commentList, NSError *error))completionHandler
{
    [self.stationManager getAllCommentsForStationId:stationId completion:^(NSMutableArray *commentList, NSError *error) {
        if (error == nil)
        {
            completionHandler(commentList, nil);
        }
        else
        {
            completionHandler(nil, error);
        }
    }];
}

- (void)addCommentForStation:(Comment *)comment
                   stationId: (long) stationId
                  completion:(void (^)(NSError *error))completionHandler
{
    [self.stationManager addCommentForStation:comment stationId:stationId completion:^(NSError *error) {
        if (error == nil)
        {
            completionHandler(nil);
        }
        else
        {
            completionHandler(error);
        }
    }];
}

- (void)updateCommentForStation:(Comment *)comment
                      stationId: (long) stationId
                     completion:(void (^)(NSError *error))completionHandler
{
    [self.stationManager updateCommentForStation:comment stationId:stationId completion:^(NSError *error) {
        if (error == nil)
        {
            completionHandler(nil);
        }
        else
        {
            completionHandler(error);
        }
    }];
}

- (void)deleteCommentForStation:(Comment *)comment
                      stationId: (long) stationId
                     completion:(void (^)(NSError *error))completionHandler
{
    [self.stationManager deleteCommentForStation:comment stationId:stationId completion:^(NSError *error) {
        if (error == nil)
        {
            completionHandler(nil);
        }
        else
        {
            completionHandler(error);
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
