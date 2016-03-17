//
//  TourViewController.m
//  ezHuddles
//
//  Created by kamlesh on 05/11/14.
//  Copyright (c) 2014 ezHuddles. All rights reserved.
//

#import "TourViewController.h"
#import "RegistrationViewController.h"
#import "SWRevealViewController.h"
#import "vipertestAppDelegate.h"

@implementation TourController

@synthesize gestureStartPoint;

#pragma mark -
#pragma mark View Did Load/Unload

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addSideMenuAction];
    
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:19.0/255.0 green:36.0/255.0 blue:184.0/255.0 alpha:1];
    //self.navigationController.navigationBar.translucent = NO;
    
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    NSNumber *alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    
    if((!alreadyStartedOnVersion || [alreadyStartedOnVersion boolValue] == NO))
    {
        //Hide menu button - First time
        
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
    else
    {
        //Hide Start button - From Menu
        
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    self.revealViewController.panGestureRecognizer.enabled=NO;
    touching = NO;
    [super viewWillAppear:animated];
    
    UIImage *img;
    
    img = [UIImage imageNamed:@"tour1.PNG"];
    
    [tourImage setImage:img];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (IBAction)changeScreen:(id)sender {
    
    [self updateTourImage];
}

- (void) updateTourImage
{
    if (pageControl.currentPage == 0)
    {
        UIImage *img;
        img = [UIImage imageNamed:@"tour1.PNG"];
        [tourImage setImage:img];
    }
    else if (pageControl.currentPage == 1)
    {
        UIImage *img;
        img = [UIImage imageNamed:@"tour2.PNG"];
        [tourImage setImage:img];
    }
    else if (pageControl.currentPage == 2)
    {
        UIImage *img;
        img = [UIImage imageNamed:@"tour3.PNG"];
        [tourImage setImage:img];
    }
    else if (pageControl.currentPage == 3)
    {
        UIImage *img;
        img = [UIImage imageNamed:@"tour4.PNG"];
        [tourImage setImage:img];
    }
    else if (pageControl.currentPage == 4)
    {
        UIImage *img;
        img = [UIImage imageNamed:@"tour5.PNG"];
        [tourImage setImage:img];
    }
}

-(void) addSideMenuAction {
    SWRevealViewController *parentRevealController = self.revealViewController;
    if (parentRevealController)
    {
        CGRect rect = self.view.bounds;
        
        parentRevealController.rearViewRevealWidth = rect.size.width * 0.8;
        self.sideMenuBarBtn.target = parentRevealController;
        self.sideMenuBarBtn.action = @selector(revealToggle:);
        [self.view addGestureRecognizer:parentRevealController.panGestureRecognizer];
    }
}


// Work with touches
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self.view];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];
    
    CGFloat deltaX = fabs(gestureStartPoint.x - currentPosition.x);
    CGFloat deltaY = fabs(gestureStartPoint.y - currentPosition.y);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if (deltaX >= kMinimumGestureLengthIPad && deltaY <= kMaximumVarianceIPad)
        {
            if (gestureStartPoint.x > currentPosition.x) {
                pageControl.currentPage = (pageControl.currentPage - 1);
                [self updateTourImage];
            }
            else {
                pageControl.currentPage = (pageControl.currentPage + 1);
                [self updateTourImage];
            }
        }
        else if (deltaY >= kMinimumGestureLengthIPad && deltaX <= kMaximumVarianceIPad)
        {
            if (gestureStartPoint.y > currentPosition.y) {
                pageControl.currentPage = (pageControl.currentPage - 1);
                [self updateTourImage];
            }
            else {
                pageControl.currentPage = (pageControl.currentPage + 1);
                [self updateTourImage];
            }
        }
    }
    else
    {
        if (deltaX >= kMinimumGestureLength && deltaY <= kMaximumVariance)
        {
            if (gestureStartPoint.x > currentPosition.x) {
                pageControl.currentPage = (pageControl.currentPage - 1);
                [self updateTourImage];
            }
            else {
                pageControl.currentPage = (pageControl.currentPage + 1);
                [self updateTourImage];
            }
        }
        else if (deltaY >= kMinimumGestureLength && deltaX <= kMaximumVariance)
        {
            if (gestureStartPoint.y > currentPosition.y) {
                pageControl.currentPage = (pageControl.currentPage - 1);
                [self updateTourImage];
            }
            else {
                pageControl.currentPage = (pageControl.currentPage + 1);
                [self updateTourImage];
            }
        }
    }
}

// Process swipes
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}



- (IBAction) closeView : (id)sender
{
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    NSNumber *alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    
    if((!alreadyStartedOnVersion || [alreadyStartedOnVersion boolValue] == NO))
    {
        //Show Registration Screen
        vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel showRegistrationView];
    }
    else
    {
        //We should never get here as this button will be hidden when user views the Tour from Menu
    }
}

#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
