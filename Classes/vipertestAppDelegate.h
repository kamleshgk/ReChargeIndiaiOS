
//
//
// Copyright (c) 2014. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegistrationViewController;
@import Firebase;

@interface vipertestAppDelegate : NSObject <UIApplicationDelegate> {
	
    UIWindow *window;
    RegistrationViewController *rootController;
    FIRDatabaseReference *ref;
}

@property (strong, nonatomic) FIRDatabaseReference *ref;

@property (nonatomic, readonly)         NSString *applicationDocumentsDirectory;
@property (nonatomic, retain) IBOutlet  UIWindow *window;


- (void) showHomeView;

- (void) showRegistrationView;

@end
