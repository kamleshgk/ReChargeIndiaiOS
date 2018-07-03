//
//  SettingsViewController.h
//
// Copyright (c) 2014. All rights reserved.
//
#import <Foundation/Foundation.h>

@protocol SettingsViewDelegate

-(void)doneSelected;

@end

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
      UITableView *settingsTableView;
      NSDictionary *settings;
    
      NSMutableArray *selectedTypes;
      int communityBusinessCount;
      int mahindraCount;
      int atherCount;
      int communityHomeCount;
      int quickChargeCount;
      int sunMobilityCount;
}

@property (weak, nonatomic) id <SettingsViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *settingsTableView;

@end
