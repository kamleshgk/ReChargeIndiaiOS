//
// ChargingStation.h
//
// Copyright (c) 2016. All rights reserved.

#import <Foundation/Foundation.h>

@interface ChargingStation : NSObject
{
    NSString*   stationid;
    NSString*   name;
    NSString*   contact;
    NSString*   address;
    NSString*   phones;
    NSString*   pricing;
    NSString*   notes;
    NSString*   type;
    NSString*   isValidated;
    NSString*   lattitude;
    NSString*   longitude;
}

@property (nonatomic, retain)     NSString*   stationid;
@property (nonatomic, retain)     NSString*   name;
@property (nonatomic, retain)     NSString*   contact;
@property (nonatomic, retain)     NSString*   address;
@property (nonatomic, retain)     NSString*   phones;
@property (nonatomic, retain)     NSString*   pricing;
@property (nonatomic, retain)     NSString*   notes;
@property (nonatomic, retain)     NSString*   type;
@property (nonatomic, retain)     NSString*   isValidated;
@property (nonatomic, retain)     NSString*   lattitude;
@property (nonatomic, retain)     NSString*   longitude;

@end

