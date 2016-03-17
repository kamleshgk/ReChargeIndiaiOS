
//
// Copyright (c) 2014. All rights reserved.
//

#import "HomeViewController.h"
#import "vipertestAppDelegate.h"
#import "RegistrationViewController.h"
#import "UserSessionInfo.h"
#import "TourViewController.h"
#import "Utils.h"
@import GoogleMaps;

@implementation vipertestAppDelegate

@synthesize window;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    viperTestDependencies *dependenciesInfo = [[viperTestDependencies alloc] init];
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    userSession.dependencies = dependenciesInfo;
    
    [GMSServices provideAPIKey:@"AIzaSyBhszcFUcJtiwZv8P0mF6GXXgLVrP-pYVM"];
    
    // Handle on Terminated state, app launched because of APN
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self performFirstStartActivities];
    
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    NSNumber *alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    
    if((!alreadyStartedOnVersion || [alreadyStartedOnVersion boolValue] == NO))
    {
        //First time show Tour View
        UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Tour" bundle:nil];
        
        TourController *controller = [mainSB instantiateViewControllerWithIdentifier:@"TourController"];
        UINavigationController *ilNavController = [[UINavigationController alloc] initWithRootViewController:controller];
        
        [window setRootViewController:ilNavController];
        [window makeKeyAndVisible];
    }
    else
    {
        //Next time show home view
        [self showHomeView];
    }
    
    return YES;
}

- (void) showRegistrationView
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RegistrationViewController *controller = [mainSB instantiateViewControllerWithIdentifier:@"RegistrationViewController"];
    UINavigationController *ilNavController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [window setRootViewController:ilNavController];
    [window makeKeyAndVisible];
}

- (void) showHomeView
{
    UIStoryboard *mainSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    id vcController = [mainSB instantiateViewControllerWithIdentifier:@"RevealViewController"];
    [window setRootViewController:vcController];
    [window makeKeyAndVisible];
}


-(void)performFirstStartActivities
{
    NSLog(@"Performing Initial DB Copy...");
    
    // Create a string containing the full path to the JSON inside the documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"ChargingStations.JSON"];
    
    
    NSString *bundleVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *appFirstStartOfVersionKey = [NSString stringWithFormat:@"first_start_%@", bundleVersion];
    NSNumber *alreadyStartedOnVersion = [[NSUserDefaults standardUserDefaults] objectForKey:appFirstStartOfVersionKey];
    
    // Get the path to the database in the application package or Bundle
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *pathOfDB = [resourcePath stringByAppendingPathComponent:@"ChargingStations.JSON"];
    
    NSString *backupFolder = [documentsDirectory stringByAppendingString:@"/backup/"];
    NSString *backupFilePath = [backupFolder stringByAppendingPathComponent:@"ChargingStations.JSON"];
    
    
    NSError *err;
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    
    if((!alreadyStartedOnVersion || [alreadyStartedOnVersion boolValue] == NO))
    {
        NSLog(@"Very First Time Launch...");
        
        //Do these only on first time launch
        
        //Pushing file
        NSLog(@"Pushing JSON from Bundle to Documents folder...");
        
        // Check to see if the JSON database file already exists
        bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
        
        // if the DB exists in the file system, then delete the DB
        if (databaseAlreadyExists)
        {
            NSLog(@"Old DB deleted...");
            [[NSFileManager defaultManager] removeItemAtPath:dbPath error:nil];
        }
        
        // Copy the database from the package to the users filesystem
        [[NSFileManager defaultManager] copyItemAtPath:pathOfDB toPath:dbPath error:&err];
        
        //Make a backup of the current database into the Documents/Backup folder
        
        //Delete the backup file if found
        if ([[NSFileManager defaultManager]  fileExistsAtPath:backupFilePath] == YES) {
            NSError *errBackup;
            [[NSFileManager defaultManager]  removeItemAtPath:backupFilePath error:&errBackup];
        }
        
        //create Backup folder
        [[NSFileManager defaultManager] createDirectoryAtPath:backupFolder withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSError *errCopy;
        // Copy the database from the documents to the backup folder
        [[NSFileManager defaultManager] copyItemAtPath:dbPath toPath:backupFilePath error:&errCopy];
        
        NSLog(@"Database created.");
        
        NSDate *myDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:myDate forKey:@"rechargedbdate"];
    }
    else
    {
        // Check to see if the database file already exists
        bool databaseAlreadyExists = [[NSFileManager defaultManager] fileExistsAtPath:dbPath];
        
        // Push the DB the database if it doesn't yet exists in the file system
        if (!databaseAlreadyExists)
        {
            //We should never get here - But better safe than Sorry!
            
            // Copy the database from the package to the users filesystem
            [[NSFileManager defaultManager] copyItemAtPath:pathOfDB toPath:dbPath error:&err];
            
            NSLog(@"Database updated");
        }
    }
    
    if (err == nil)
    {
        userSession.databasePath = dbPath;
    }
    else
    {
        NSLog(@"Alert!!!  Could not move DB in the documents folder");
        userSession.databasePath = pathOfDB;
    }
    
    userSession.databaseBackupPath = backupFilePath;
    
    NSString *communityKey = [Utils getStationTypeToNumberString:Community];
    NSString *revaKey = [Utils getStationTypeToNumberString:Mahindra];
    NSString *QCKey = [Utils getStationTypeToNumberString:QuickCharge];
    
    NSMutableArray *arrayTypes = [[NSMutableArray alloc]init];
    
    [arrayTypes addObject:communityKey];
    [arrayTypes addObject:revaKey];
    [arrayTypes addObject:QCKey];
    
    userSession.displayStationTypes = arrayTypes;
    
    double radius = [CHARGING_STATION_MARKER_DISTANCE floatValue];
    userSession.distanceToBeCovered = radius;
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}

- (void)applicationDidEnterForeground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {

    
}





#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	
}

@end
