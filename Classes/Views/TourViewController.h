//
//  TourViewController.h
//  Copyright (c) 2016 ReCharge India. All rights reserved.
//

#import <UIKit/UIKit.h>

// Constants associated with swiping
#define kMinimumGestureLength       25
#define kMaximumVariance            100

#define kMinimumGestureLengthIPad   300
#define kMaximumVarianceIPad        200

@interface TourController : UIViewController
{
    IBOutlet UIPageControl *pageControl;
    IBOutlet UIImageView *tourImage;
    IBOutlet UIButton *btnClose;
	CGPoint	 gestureStartPoint;
    
    BOOL touching;
}

- (IBAction)changeScreen:(id)sender;

- (IBAction) closeView : (id)sender;

@property CGPoint gestureStartPoint;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *sideMenuBarBtn;  //Need this for left nav
@property (nonatomic, strong) IBOutlet UIBarButtonItem *closeBarBtn;  //Need this for first time close

@end
