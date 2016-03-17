//
//  AddStationViewController.h
//
// Copyright (c) 2014. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface AddStationViewController : UIViewController
{
    IBOutlet UITextField *emailTextField;
    IBOutlet UITextField *nameTextField;
    IBOutlet UITextView *addressTextView;
    IBOutlet UITextField *NoChargePointsTextField;
    IBOutlet UITextField *timingTextField;
    IBOutlet UITextField *phoneTextField;
    IBOutlet UITextField *costTextField;
    IBOutlet UITextView *compatibilityTextField;
    IBOutlet UITextView *infoTextField;
    
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *contentView;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *sideMenuBarBtn;  //Need this for left nav

@end