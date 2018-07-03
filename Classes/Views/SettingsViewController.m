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
    
    communityBusinessCount = 0;
    mahindraCount = 0;
    atherCount = 0;
    communityHomeCount = 0;
    quickChargeCount = 0;
    sunMobilityCount = 0;
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    for (ChargingStation *station in userSession.stationsCache)
    {
        if (CommunityBusiness == [Utils getStationStringToStationType:station.type])
        {
            communityBusinessCount++;
        }
        else if (CommunityHome == [Utils getStationStringToStationType:station.type])
        {
            communityHomeCount++;
        }
        else if (Mahindra == [Utils getStationStringToStationType:station.type])
        {
            mahindraCount++;
        }
        else if (Ather == [Utils getStationStringToStationType:station.type])
        {
            atherCount++;
        }
        else if (QuickCharge == [Utils getStationStringToStationType:station.type])
        {
            quickChargeCount++;
        }
        else if (SunMobility == [Utils getStationStringToStationType:station.type])
        {
            sunMobilityCount++;
        }
    }
    
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

    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]init];
    [mutableDict setObject:@"Community Points (Residence)" forKey:communityHomeKey];
    [mutableDict setObject:@"Mahindra Electric Dealers" forKey:revaKey];
    [mutableDict setObject:@"Ather Charge Pods" forKey:ather];
    [mutableDict setObject:@"Community Points (Business)" forKey:communityBusinessKey];
    [mutableDict setObject:@"DC Quick Charge Stations" forKey:QCKey];
    [mutableDict setObject:@"Sun Mobility Quick Interchange Stations" forKey:sun];
    
    settings = mutableDict;
    
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
    return 70;
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
    NSString *detailCountLabel = @"";
    if ([key isEqualToString:[Utils getStationTypeToNumberString:CommunityHome]])
    {
        settingImage = [UIImage imageNamed:@"communityHome"];
        detailCountLabel = [NSString stringWithFormat:@"%d homes have offered charging to the community!", communityHomeCount];
    }
    else if ([key isEqualToString:[Utils getStationTypeToNumberString:Mahindra]])
    {
        settingImage = [UIImage imageNamed:@"mahindra"];
        detailCountLabel = [NSString stringWithFormat:@"%d dealers of Mahindra offer charging to Mahindra Electric Cars only.", mahindraCount];
    }
    else if ([key isEqualToString:[Utils getStationTypeToNumberString:Ather]])
    {
        settingImage = [UIImage imageNamed:@"ather"];
        detailCountLabel = [NSString stringWithFormat:@"%d Ather Energy charge pods, offer charging to Ather electric scooters & all EV's. Use the 'Ather Grid' app to use these points.", atherCount];
    }
    else if ([key isEqualToString:[Utils getStationTypeToNumberString:CommunityBusiness]])
    {
        settingImage = [UIImage imageNamed:@"communityBus"];
        detailCountLabel = [NSString stringWithFormat:@"%d businesses offer charging to all EV's!", communityBusinessCount];
    }
    else if ([key isEqualToString:[Utils getStationTypeToNumberString:QuickCharge]])
    {
        settingImage = [UIImage imageNamed:@"fastCharger"];
        detailCountLabel = [NSString stringWithFormat:@"%d DC Quick charge stations, that offers rapid charging of electric cars at > 10 kw!", quickChargeCount];
    }
    else if ([key isEqualToString:[Utils getStationTypeToNumberString:SunMobility]])
    {
        settingImage = [UIImage imageNamed:@"sun"];
        if (sunMobilityCount == 1)
        {
            detailCountLabel = [NSString stringWithFormat:@"%d Sun Mobility quick interchange station for battery swapping!", sunMobilityCount];
        }
        else
        {
            detailCountLabel = [NSString stringWithFormat:@"%d Sun Mobility quick interchange stations for battery swapping!", sunMobilityCount];
        }
    }
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = label;
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.text = detailCountLabel;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
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
