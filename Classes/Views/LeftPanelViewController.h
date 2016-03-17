//
//  LeftViewController.h
//
// Copyright (c) 2014. All rights reserved.
//



@interface LeftPanelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
      UITableView *leftNavTableView;
}

@property (nonatomic, retain) IBOutlet UITableView *leftNavTableView;

@end