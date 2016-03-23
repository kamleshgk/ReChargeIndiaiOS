//
// AuthorManager.m
//
// Copyright (c) 2014. All rights reserved.
//

#import "ChargingStationManager.h"
#import "UserSessionInfo.h"
#import "Utils.h"
#import "ChargingStation.h"

@implementation ChargingStationManager


- (void)downloadUpdatedStationDB:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    //To be implemented
    completionHandler(nil, error);
    return;
}

- (void)getStationsNearCordinate:(CLLocationCoordinate2D)coordinates
                      completion:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSMutableArray *stations = userSession.stationsCache;
    NSMutableArray *matchingStations = [[NSMutableArray alloc] init];
    
    if (stations == nil)
    {
        //Just in case
        
        NSString *jsonPath = userSession.databasePath;
        
        NSError *error = nil;;
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:jsonPath] options:kNilOptions error:&error];
    
        if (error != nil)
        {
            completionHandler(nil, error);
            return;
        }
        
        NSArray *arrayOfStations = dataDict[@"data"];
        
        stations = [self serializeJSON:arrayOfStations];
    }
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
    
    double radius = userSession.distanceToBeCovered;
    
    for(ChargingStation *station in stations)
    {
        CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:[station.lattitude floatValue] longitude:[station.longitude floatValue]];

        CLLocationDistance meters = [stationLocation distanceFromLocation:userLocation];
        
        if (meters <= radius)
        {
            [matchingStations addObject:station];
        }
    }
    
    BOOL isSuccess = YES;
    
    if (!isSuccess)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not"
                                   " load stations as there are no stations in the inventory."};
        
        NSError *error = [NSError errorWithDomain:CHARGING_STATION_ERRORDOMAIN
                                             code:StationNotLoadedError
                                         userInfo:userInfo];
        completionHandler(nil, error);
    }
    else
    {
        completionHandler(matchingStations, nil);
    }
}



- (void) getAllStations:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *jsonPath = userSession.databasePath;
    
    NSError *error = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (error != nil)
    {
        completionHandler(nil, error);
        return;
    }
    
    NSString *version = dataDict[@"version"];
    userSession.dbVersion = version;
    
    NSArray *arrayOfStations = dataDict[@"data"];
    
    NSMutableArray *stations = [self serializeJSON:arrayOfStations];
    
    if (stations == nil)
    {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Could not"
                                   " load stations as there are no stations in the inventory."};
        
        NSError *error = [NSError errorWithDomain:CHARGING_STATION_ERRORDOMAIN
                                             code:StationNotLoadedError
                                         userInfo:userInfo];
        
        completionHandler(nil, error);
    }
    else
    {
        completionHandler(stations, nil);
    }
}

//private
- (NSMutableArray *) serializeJSON:(NSArray *)arrayOfStations
{
    if (arrayOfStations.count <= 0)
        return nil;
    
    NSMutableArray *stations = [[NSMutableArray alloc] initWithCapacity:arrayOfStations.count];
    
    for (NSDictionary *dict in arrayOfStations) {
    
        ChargingStation *station = [[ChargingStation alloc]init];
        station.stationid = dict[@"stationid"];
        station.name = dict[@"name"];
        station.contact = dict[@"contact"];
        station.address = dict[@"address"];
        station.phones = dict[@"phones"];
        station.pricing = dict[@"pricing"];
        station.notes = dict[@"notes"];
        station.type = dict[@"type"];
        station.isValidated = dict[@"isValidated"];
        station.lattitude = dict[@"lattitude"];
        station.longitude = dict[@"longitude"];
        
        [stations addObject:station];
    }
    
    return stations;
}


@end
