//
//  UserSessionInfo.h
//
// Copyright (c) 2014. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "viperTestDependencies.h"

//This is a Singleton class that is cached as long as the app is operating.
//Logon info is stored here and is used throught the app
@interface UserSessionInfo : NSObject
{
    NSString *databasePath;
    NSString *databaseBackupPath;
    NSString *dbVersion;
    NSMutableArray *stationsCache;
    
    NSMutableArray *displayStationTypes;
    float distanceToBeCovered;          //in km
    CLLocationCoordinate2D currentUserLocation;    
    
    viperTestDependencies *dependencies;
}

@property (nonatomic, copy) NSString *databasePath;
@property (nonatomic, copy) NSString *databaseBackupPath;
@property (nonatomic, copy) NSString *dbVersion;
@property (nonatomic, copy) NSMutableArray *stationsCache;
@property (nonatomic, copy) NSMutableArray *displayStationTypes;
@property (nonatomic, assign) float distanceToBeCovered;

@property (nonatomic, assign) CLLocationCoordinate2D currentUserLocation;

@property (nonatomic, strong) viperTestDependencies *dependencies;

+ (UserSessionInfo *)sharedUser;

@end
