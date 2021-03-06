//
//  Utils.h
//  vipertest
//
//  Created by Kamlesh Mallick on 21/12/14.
//
//

#import <Foundation/Foundation.h>


#define		CHARGING_STATION_ERRORDOMAIN			@"com.recharge.station.ErrorDomain"
#define		CHARGING_STATION_MARKER_DISTANCE		@"200000"  //200 Kilometers (200 Meters)
#define     STAGE_DB_PATH                           @"https://drive.google.com/uc?export=download&id=0B474e0D1-uDrUWZieTB5MUh0VVk"
#define     PROD_DB_PATH                            @"https://drive.google.com/uc?export=download&id=1vCEXffSilU3GSN-rky3zYr4IKxqanfYc"

typedef enum {
    CommunityBusiness = 1,
    Mahindra,
    Ather,
    CommunityHome,
    QuickCharge,
    SunMobility
} StationType;


typedef enum {
    AddCommunityStation = 1,
    FAQ,
    AboutUs,
    Privacy,
    Terms,
} AboutWebItem;

enum {
   StationNotLoadedError = 1,
   StationEmptyError,
   StationInternalError
};

@interface Utils : NSObject
{
    
    
    
}

+ (NSString *)relativeDateStringForDate:(NSDate *)date;

+ (NSString *) getStationTypeToNumberString:(StationType)huddleKind;

+ (StationType) getStationStringToStationType:(NSString *)huddleString;

+ (NSString *)getTrimmedString: (NSString *)inputString;

+(UIFont *)getAppFont;
+(UIFont *)getAppBoldFont;

+(UIFont *)getiPadAppFont;
+(UIFont *)getiPadAppBoldFont;

@end
