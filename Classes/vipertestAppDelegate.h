
//
//
// Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistrationViewController;

@interface vipertestAppDelegate : NSObject <UIApplicationDelegate> {
	
    UIWindow *window;
    RegistrationViewController *rootController;
}

@property (nonatomic, readonly)         NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) IBOutlet  UIWindow *window;


- (void) showHomeView;

- (void) showRegistrationView;

@end
