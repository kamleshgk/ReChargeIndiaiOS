//
// ChargingStationManager.h
//
// Copyright (c) 2014. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "ChargingStation.h"
#import "Comment.h"
@import CoreLocation;
@import Firebase;

@interface ChargingStationManager : NSObject
{
    
}

- (void)doesLocalDBNeedUpdate:(void (^)(BOOL serverDBChanged, NSError *error))completionHandler;

- (void)downloadUpdatedStationDB:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getAllStations:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getStationsNearCordinate:(CLLocationCoordinate2D)coordinates
                            completion:(void (^)(NSMutableArray *stationList, NSError *error))completionHandler;

- (void)getAllCommentsForStationId:(NSString *)stationId
                        completion:(void (^)(NSMutableArray *commentList, NSError *error))completionHandler;

- (void)addCommentForStation:(Comment *)comment
                    stationId: (long) stationId
                    completion:(void (^)(NSError *error))completionHandler;


- (void)updateCommentForStation:(Comment *)comment
                    stationId: (long) stationId
                    completion:(void (^)(NSError *error))completionHandler;

- (void)deleteCommentForStation:(Comment *)comment
                      stationId: (long) stationId
                     completion:(void (^)(NSError *error))completionHandler;

@end
