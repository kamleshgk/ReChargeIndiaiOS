//
//  ChargingStationDetailsViewController.j
//
// Copyright (c) 2014. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChargingStation.h"
#import "ReportUsViewController.h"
#import "MessageViewController.h"

@protocol ChargingStationDetailsDelegate

-(void)doneSelectedDetails;

@end

@interface ChargingStationDetailsViewController : UIViewController<ReportUsDelegate, MessageDelegate>
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
      IBOutlet UIButton *commentButton;
      IBOutlet UILabel *commentCountLabel;
      IBOutlet UIButton *shareButton;
      IBOutlet UILabel *totalCommentCountLabel;
    
      ChargingStation *station;
      IBOutlet UIActivityIndicatorView *activityGuy;
      NSMutableArray *commentObjectList;
}

@property (weak, nonatomic) id <ChargingStationDetailsDelegate> delegate;

@property (strong, nonatomic) ChargingStation *station;

@end
