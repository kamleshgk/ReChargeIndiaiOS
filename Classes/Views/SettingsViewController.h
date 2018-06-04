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
    
}

@property (weak, nonatomic) id <SettingsViewDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *settingsTableView;

@end
