//
//  UpdateDBViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "UpdateDBViewController.h"
#import "SWRevealViewController.h"
#import "UserSessionInfo.h"
#import "ChargingStationPresenter.h"
#import "SVProgressHud.h"
#import "WSService.h"
#import "Utils.h"

@implementation UpdateDBViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{

}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [self addSideMenuAction];
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *totalStations = [NSString stringWithFormat:@"%lu", (unsigned long)userSession.stationsCache.count];
    
    NSString *dbVersion = [NSString stringWithFormat:@"%.01f", [userSession.dbVersion floatValue]];
    
    databaseVersion.text = dbVersion;
    stationCount.text = totalStations;
    
    NSDate *myDate = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:@"rechargedbdate"];
    databaseDateAdded.text = [Utils relativeDateStringForDate:myDate];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
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

#pragma mark - Private

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

#pragma mark - IBButton Handlers


- (IBAction)UpdateDBNow:(id)sender {
    
   if (![WSService checkInternet:NO])
   {
     [WSService showNetworkAlert];
     return;
   }
    
   [updateButton setEnabled:NO];
    
   [SVProgressHUD showWithStatus:@"Checking for updated database..."];
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    ChargingStationPresenter *presentor = userSession.dependencies.chargingStationPresenter;
    
    [presentor downloadUpdatedStationDB:^(NSMutableArray *stationList, NSError *error) {
        [updateButton setEnabled:YES];
        if (error == nil)
        {
            UserSessionInfo *userSession = [UserSessionInfo sharedUser];
            NSString *totalStations = [NSString stringWithFormat:@"%lu", (unsigned long)userSession.stationsCache.count];
            
            NSString *dbVersion = [NSString stringWithFormat:@"%.01f", [userSession.dbVersion floatValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                databaseVersion.text = dbVersion;
                stationCount.text = totalStations;
                databaseDateAdded.text = [Utils relativeDateStringForDate:[NSDate date]];

                NSDate *myDate = [NSDate date];
                [[NSUserDefaults standardUserDefaults] setObject:myDate forKey:@"rechargedbdate"];
                
                [SVProgressHUD showInfoWithStatus:@"The database is now updated."];
            });
        }
        else
        {
            NSDictionary *errDict = error.userInfo;
            NSString *errorMessage = errDict[@"errmessage"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showErrorWithStatus:errorMessage];
            });
        }
    }];
    
    return;
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
