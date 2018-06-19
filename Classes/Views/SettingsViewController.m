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
    
    if (selectedTypes.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please select atleast 1 charge point type to be displayed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (NSString *someString in selectedTypes) {
        [arr addObject:someString];
    }
    
    userSession.displayStationTypes = arr;
    
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
    
    NSString *communityHomeKey = [Utils getStationTypeToNumberString:CommunityHome];
    NSString *communityBusinessKey = [Utils getStationTypeToNumberString:CommunityBusiness];
    NSString *ather = [Utils getStationTypeToNumberString:Ather];
    NSString *sun = [Utils getStationTypeToNumberString:SunMobility];
    NSString *revaKey = [Utils getStationTypeToNumberString:Mahindra];
    NSString *QCKey = [Utils getStationTypeToNumberString:QuickCharge];

    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"Community Points (Residence)", communityHomeKey, @"Mahindra Electric Dealers", revaKey, @"Ather Charge Pods", ather, @"Community Points (Business)", communityBusinessKey, @"DC Quick Charge Stations", QCKey, @"Sun Mobility Quick Interchange Stations", sun,nil];

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
        settingImage = [UIImage imageNamed:@"communityHome"];
    }
    else if (row == 1)
    {
        settingImage = [UIImage imageNamed:@"mahindra"];
    }
    else if (row == 2)
    {
        settingImage = [UIImage imageNamed:@"ather"];
    }
    else if (row == 3)
    {
        settingImage = [UIImage imageNamed:@"communityBus"];
    }
    else if (row == 4)
    {
        settingImage = [UIImage imageNamed:@"fastCharger"];
    }
    else if (row == 5)
    {
        settingImage = [UIImage imageNamed:@"sun"];
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
