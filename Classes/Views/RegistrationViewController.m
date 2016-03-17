//
//  RegistrationViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "RegistrationViewController.h"
#import "SWRevealViewController.h"
#import "vipertestAppDelegate.h"

@implementation RegistrationViewController

#pragma mark -
#pragma mark View Did Load/Unload

-(void)viewDidLoad
{
    self.title = @"Welcome";
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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


#pragma mark - Private methods



#pragma mark - Button Handlers

- (IBAction) getStarted : (id)sender
{
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    //Registration is succesfull, only then set this
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:appFirstStartOfVersionKey];
    
    vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDel showHomeView];
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
