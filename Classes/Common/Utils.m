//
//  Utils.m
//  vipertest
//
//  Created by Kamlesh Mallick on 21/12/14.
//
//

#import "Utils.h"
#import "UserSessionInfo.h"

@implementation Utils


+ (NSString *)relativeDateStringForDate:(NSDate *)date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
                        NSCalendarUnitMonth | NSCalendarUnitYear;
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:date
                                                                     toDate:[NSDate date]
                                                                    options:0];
    
    if (components.year > 0) {
        
        if (components.year > 0) {
            return [NSString stringWithFormat:@"%ld year ago", (long)components.year];
        }
        else
        {
            return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
        }
    } else if (components.month > 0) {
        return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
    } else if (components.weekOfYear > 0) {
        return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
    } else if (components.day > 0) {
        if (components.day > 1) {
            return [NSString stringWithFormat:@"%ld days ago", (long)components.day];
        } else {
            return @"Yesterday";
        }
    } else {
        return @"Today";
    }
}

+ (NSString *) getStationTypeToNumberString:(StationType)huddleKind;
{
    NSString *result = nil;
    
    switch(huddleKind) {
        case CommunityBusiness:
        result = @"1";
        break;
        case Mahindra:
        result = @"2";
        break;
        case Ather:
        result = @"3";
        break;
        case CommunityHome:
        result = @"4";
        break;
        case QuickCharge:
        result = @"5";
        break;
        case SunMobility:
        result = @"6";
        break;
        default:
          result = @"1";
    }
    
    return result;
}


+ (StationType) getStationStringToStationType:(NSString *)huddleString
{
    StationType result;
    
    if ([huddleString isEqualToString:@"1"])
    {
        result = CommunityBusiness;
    }
    else if ([huddleString isEqualToString:@"2"])
    {
        result = Mahindra;
    }
    else if ([huddleString isEqualToString:@"3"])
    {
        result = Ather;
    }
    else if ([huddleString isEqualToString:@"4"])
    {
        result = CommunityHome;
    }
    else if ([huddleString isEqualToString:@"5"])
    {
        result = QuickCharge;
    }
    else if ([huddleString isEqualToString:@"6"])
    {
        result = SunMobility;
    }
    else
    {
        result = CommunityBusiness;
    }

    return result;

}



+ (NSString *)getTrimmedString: (NSString *)inputString
{
    NSString* outputString = inputString;
    outputString = [outputString stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return outputString;
}


#pragma mark -
#pragma mark Return the font for the application

+(UIFont *)getAppFont{
    return [UIFont fontWithName:@"HelveticaNeue" size:15.0];
}

+(UIFont *)getAppBoldFont{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
}

+(UIFont *)getiPadAppFont{
    return [UIFont fontWithName:@"HelveticaNeue" size:20.0];
}

+(UIFont *)getiPadAppBoldFont{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
}

@end
