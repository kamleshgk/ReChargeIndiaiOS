//
//  AboutViewController
//
//  Copyright (c) 2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController <UIWebViewDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UIButton *btnClose;
    IBOutlet UILabel *lableTitle;
    
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UINavigationItem *item;

    //0 - We show About Us view
    //1 - We show Terms and Conditions view
    //2 - We show Privacy Policy view
    int contentFlag;
}


@property (nonatomic, assign) int contentFlag;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) IBOutlet UIBarButtonItem *sideMenuBarBtn;  //Need this for left nav

@end
