//
//  SettingsViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "SettingsViewController.h"
#import "UserSessionInfo.h"
#import "Utils.h"

#define ROW_HEIGHT 50


@implementation SettingsViewController

@synthesize settingsTableView;

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    settingsTableView.rowHeight = UITableViewAutomaticDimension;
    settingsTableView.estimatedRowHeight = 81.0;
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *distance = [NSString stringWithFormat:@"%.0f", (userSession.distanceToBeCovered * 0.001)];
    
    distanceTextField.text = distance;
    
    selectedTypes = [[NSMutableArray alloc]init];
    
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

- (IBAction)donePressed:(id)sender {
    
    [distanceTextField resignFirstResponder];
    
    if (([distanceTextField.text floatValue] < 10) || ([distanceTextField.text floatValue] > 200))
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Enter distance between 10 and 200 km" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    if (selectedTypes.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please select atleast 1 charging station type to be displayed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSString *someString in selectedTypes) {
        [arr addObject:someString];
    }
    
    userSession.displayStationTypes = arr;
    
    userSession.distanceToBeCovered = ([distanceTextField.text floatValue] * 1000);
    
    [self.delegate doneSelected];
}

#pragma mark -
#pragma mark Array Setup

- (void)setupSettingsArray
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    
    for(NSString *type in userSession.displayStationTypes)
    {
        [selectedTypes addObject:type];
    }
    
    NSString *communityKey = [Utils getStationTypeToNumberString:Community];
    NSString *revaKey = [Utils getStationTypeToNumberString:Mahindra];
    NSString *QCKey = [Utils getStationTypeToNumberString:QuickCharge];
        
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Community Charging Stations", communityKey, @"Mahindra Reva stations", revaKey, @"DC Quick charge stations", QCKey, nil];

    settings = dict;
    
    [settingsTableView reloadData];
}

#pragma mark -
#pragma mark UITableView Datasource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settings count];
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
    return @"";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"TypeCell" forIndexPath:indexPath];
    
    // Set up the cell...
    NSUInteger row = [indexPath row];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;

    NSString *key = [NSString stringWithFormat:@"%lu", (row + 1)];
    NSString *label = settings[key];
	
    UIImage *settingImage;
    if (row == 0)
    {
        settingImage = [UIImage imageNamed:@"green"];
    }
    else if (row == 1)
    {
        settingImage = [UIImage imageNamed:@"red"];
    }
    else
    {
        settingImage = [UIImage imageNamed:@"blue"];
    }
    
    cell.textLabel.text = label;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    cell.imageView.image = settingImage;
    
    BOOL found = NO;
    
    for (NSString *someString in selectedTypes) {
        if ([someString isEqualToString:key])
        {
            found = YES;
            break;
        }
    }
    
    cell.accessoryType = found ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger row = [indexPath row];
    NSString *key = [NSString stringWithFormat:@"%lu", (row + 1)];

    BOOL found = NO;
    
    for (NSString *someString in selectedTypes) {
        if ([someString isEqualToString:key])
        {
            found = YES;
            break;
        }
    }
    
    if (found)
    {
        [selectedTypes removeObject:key];
    }
    else
    {
        [selectedTypes addObject:key];
    }
    
    [settingsTableView reloadData];
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
