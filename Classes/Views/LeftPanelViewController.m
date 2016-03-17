//
//  LeftViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "LeftPanelViewController.h"
#import "vipertestAppDelegate.h"
#import "AboutViewController.h"
#import "LeftNavCell.h"
#import "Utils.h"

#define ROW_HEIGHT 50

@interface LeftPanelViewController ()

@property (nonatomic, strong) NSMutableArray *arrayOfSettings;
@property (nonatomic, strong) NSMutableArray *arrayOfImagesForSettings;


@end

@implementation LeftPanelViewController

@synthesize leftNavTableView;

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    leftNavTableView.rowHeight = UITableViewAutomaticDimension;
    leftNavTableView.estimatedRowHeight = 81.0;
    
    [self setupSettingsArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [leftNavTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
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

#pragma mark -
#pragma mark Array Setup

- (void)setupSettingsArray
{
    NSString *string = @"";
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:[string stringByAppendingString:@"Home"]];
    [items addObject:[string stringByAppendingString:@"Update Charge Point List"]];
    [items addObject:[string stringByAppendingString:@"Add Charge Point"]];
    [items addObject:[string stringByAppendingString:@"About App"]];
    [items addObject:[string stringByAppendingString:@"Support Center"]];
    [items addObject:[string stringByAppendingString:@"App Tutorial"]];
    [items addObject:[string stringByAppendingString:@"Share the App"]];
    [items addObject:[string stringByAppendingString:@"Privacy Policy"]];
    [items addObject:[string stringByAppendingString:@"Terms of Use"]];

    string = @"";
    NSMutableArray *itemsImages = [[NSMutableArray alloc] init];
    [itemsImages addObject:[string stringByAppendingString:@"01_Home.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"02_Update Charge Points List.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"03_Add Charge Point.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"04_About App.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"05_Support Center.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"06_App Tutorial.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"07_Share App.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"08_Privacy Policy.png"]];
    [itemsImages addObject:[string stringByAppendingString:@"09_Terms of Use.png"]];
    
    self.arrayOfImagesForSettings = itemsImages;
    self.arrayOfSettings = items;
    
    [leftNavTableView reloadData];
}

#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.arrayOfSettings count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 46;
}


-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}


-(CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

-(UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Functions";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftNavCell *cell = (LeftNavCell *) [tableView dequeueReusableCellWithIdentifier:@"LeftNavRCell"];
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    
    // Set up the cell...
	NSUInteger row = [indexPath row];
	
    if ([self.arrayOfSettings count] > 0)
    {
        NSString *item = nil;
        item = [self.arrayOfSettings objectAtIndex:row];
        
        NSString *itemImage = nil;
        itemImage = [self.arrayOfImagesForSettings objectAtIndex:row];
        
        cell.menuItemName = item;
        cell.imageName = itemImage;
    }
    
    [cell render];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	NSUInteger row = [indexPath row];

    if (row == 0)
    {
        vipertestAppDelegate *appDel = (vipertestAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDel showHomeView];
    }
    else if (row == 1)
    {
        [self performSegueWithIdentifier:@"SegueToUpdate" sender:nil];
    }
    else if (row == 2)
    {
        [self performSegueWithIdentifier:@"SegueToAddStation" sender:nil];
    }
    else if ((row == 3) || (row == 4) || (row == 7) || (row == 8))
    {
        [self performSegueWithIdentifier:@"SegueToAbout" sender:indexPath];
    }
    else if (row == 5)
    {
        [self performSegueWithIdentifier:@"SegueToTour" sender:nil];
    }
    if (row == 6)
    {
        NSString *textToShare = [NSString stringWithFormat:@"Hi! \nYour friend just invited you to try ReCharge India iOS App! \n\nFind Electric Vehicle Charging Stations in India! \n\n"];
        
        NSArray * activityItems = @[textToShare, [NSURL URLWithString:@"http://www.pluginindia.com/charging"]];
        
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        
        NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                       UIActivityTypePrint,
                                       UIActivityTypeSaveToCameraRoll,
                                       UIActivityTypeAddToReadingList,
                                       UIActivityTypePostToFlickr,
                                       UIActivityTypePostToVimeo];
        
        activityVC.excludedActivityTypes = excludeActivities;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark Seque stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToAbout"])
    {
        NSIndexPath *indexPath = (NSIndexPath *) sender;
      	NSUInteger row = [indexPath row];
        
        UINavigationController *navVC = (UINavigationController *) segue.destinationViewController;
        AboutViewController *detailVC = (AboutViewController *) navVC.topViewController;
        
        if (row == 2)
        {
            detailVC.contentFlag = AddCommunityStation;
        }
        else if(row == 3)
        {
            detailVC.contentFlag = AboutUs;
        }
        else if(row == 4)
        {
            detailVC.contentFlag = FAQ;
        }
        else if(row == 7)
        {
            detailVC.contentFlag = Privacy;
        }
        else if(row == 8)
        {
            detailVC.contentFlag = Terms;
        }
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
