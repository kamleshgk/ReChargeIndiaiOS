//
//  UpdateDBViewController.h
//
// Copyright (c) 2014. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface UpdateDBViewController : UIViewController
{
      IBOutlet UILabel *databaseVersion;
      IBOutlet UILabel *databaseDateAdded;
      IBOutlet UILabel *stationCount;
      IBOutlet UIButton *updateButton;
      BOOL fromAutoUpdate;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *sideMenuBarBtn;  //Need this for left nav
@property (nonatomic, assign) BOOL fromAutoUpdate;

@end
