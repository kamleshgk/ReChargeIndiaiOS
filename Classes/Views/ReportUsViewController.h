//
//  ReportUsViewController.h
//
// Copyright (c) 2014. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ChargingStation.h"

@protocol ReportUsDelegate

-(void)closeReport;

@end

@interface ReportUsViewController : UIViewController
{
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextField *phoneTextField;
    IBOutlet UITextView *reportTextView;
    
    ChargingStation *stationDetails;
}

@property (weak, nonatomic) id <ReportUsDelegate> delegate;

@property (nonatomic, retain) ChargingStation *stationDetails;

@end