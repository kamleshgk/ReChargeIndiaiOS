//
//  ChargingStationDetailsViewController.j
//
// Copyright (c) 2014. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChargingStation.h"
#import "ReportUsViewController.h"

@protocol ChargingStationDetailsDelegate

-(void)doneSelectedDetails;

@end

@interface ChargingStationDetailsViewController : UIViewController<ReportUsDelegate>
{
      IBOutlet UILabel *stationName;
      IBOutlet UILabel *contactName;
      IBOutlet UILabel *address;
      IBOutlet UITextView *phones;
      IBOutlet UILabel *pricing;
      IBOutlet UILabel *notes;
      IBOutlet UIImageView *verifiedImageView;
      IBOutlet UIImageView *chargingTypeImageView;
    
      IBOutlet UIScrollView *scrollView;
    
      ChargingStation *station;
}

@property (weak, nonatomic) id <ChargingStationDetailsDelegate> delegate;

@property (strong, nonatomic) ChargingStation *station;

@end