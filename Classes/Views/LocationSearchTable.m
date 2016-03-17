//
//  LocationSearchTable.m
//  ReLive
//
//  Created by kamyFCMacBook on 1/27/16.
//
//

#import "LocationSearchTable.h"
#import "ChargingStation.h"
#import "UserSessionInfo.h"

@implementation LocationSearchTable

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark === UISearchResultsUpdating ===
#pragma mark -

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText
{
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    if (userSession.stationsCache.count > 0)
    {
         NSString *predicateFormat = @"(%K contains[cd] %@) OR (%K contains[cd] %@)";
         NSString *searchAttribute1 = @"address";
         NSString *searchAttribute2 = @"name";
         
         NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute1, searchText, searchAttribute2, searchText];
        
         NSArray *filtered = [userSession.stationsCache filteredArrayUsingPredicate:predicate];
        
         NSMutableArray *mutableArray = [NSMutableArray arrayWithArray: filtered];
         self.filteredList = mutableArray;
        [self.tableView reloadData];
    }
}



#pragma mark -
#pragma mark === UITableViewDataSource Delegate Methods ===
#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.filteredList == nil)
        return 0;
    
    if ([self.filteredList count] == 0) {
        return 1; // a single cell to report no data
    }
    
    return self.filteredList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // Set up the cell...
    NSUInteger row = [indexPath row];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    
    if ((row == 0) && (self.filteredList.count == 0))
    {
        cell.textLabel.text = @"No stations found";
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
        cell.detailTextLabel.text = @"";
        cell.imageView.image = [UIImage imageNamed:@"nostations"];;
        return cell;
    }
    
    ChargingStation *station = self.filteredList[row];
    NSString *label = station.name;
    
    UIImage *settingImage;
    if ([station.type integerValue] == 1)
    {
        settingImage = [UIImage imageNamed:@"green"];
    }
    else if ([station.type integerValue] == 2)
    {
        settingImage = [UIImage imageNamed:@"red"];
    }
    else if ([station.type integerValue] == 3)
    {
        settingImage = [UIImage imageNamed:@"blue"];
    }
    else
    {
        settingImage = [UIImage imageNamed:@"green"];
    }
    
    cell.textLabel.text = label;
    cell.detailTextLabel.text = station.address;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    cell.imageView.image = settingImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Set up the cell...
    NSUInteger row = [indexPath row];
 
    if (self.filteredList == nil)
        return;

    if (self.filteredList.count == 0)
        return;
    
    ChargingStation *station = self.filteredList[row];
    [self.delegate dropPinZoomIn:station];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
