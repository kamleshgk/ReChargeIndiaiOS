//
//  ChargingStationDetailsViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "ChargingStationDetailsViewController.h"
#import "UserSessionInfo.h"
#import "Utils.h"

@implementation ChargingStationDetailsViewController

@synthesize station;

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, 1500)];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
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
    stationName.text = station.name;
    contactName.text = station.contact;
    address.text = station.address;
    phones.text = station.phones;
    pricing.text = station.pricing;
    notes.text = station.notes;
    
    UIBarButtonItem *btnDirections = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                             style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(donePressed:)];
    
    UIBarButtonItem *btnReport = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"report.png"]
                                                                     imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                     style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(showReportForm:)];
    
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnDirections, btnReport, nil]];
    
    NSInteger isValidated = [station.isValidated integerValue];
    if (isValidated == 1)
    {
        verifiedImageView.image = [UIImage imageNamed:@"verified_tick"];
    }
    else
    {
        verifiedImageView.image = [UIImage imageNamed:@"notVerified"];
    }
    
    NSInteger chargeStationType = [station.type integerValue];
    if (chargeStationType == 1)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"green"];
    }
    else if (chargeStationType == 2)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"red"];
    }
    else if (chargeStationType == 3)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"blue"];
    }
    else
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"green"];        
    }
    
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


- (IBAction)showDirections:(id)sender {
    
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    NSString *sourceLocation = [NSString stringWithFormat:@"%f,%f", userSession.currentUserLocation.latitude, userSession.currentUserLocation.longitude];
    NSString *destinationLocation = [NSString stringWithFormat:@"%@,%@", station.lattitude, station.longitude];
    
    NSString *url;
    
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) {
        
        //Use google Maps app
        
        url = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@", destinationLocation];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    } else {
        
        //Use google Maps in browser
        
        NSLog(@"Can't use comgooglemaps://");
        
        url = [NSString stringWithFormat:@"http://maps.google.com/maps?f=d&saddr=%@&daddr=%@", sourceLocation, destinationLocation];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (IBAction)makePhoneCall:(id)sender {

    NSString *phoneNumbers = [Utils getTrimmedString:station.phones];
    
    if (phoneNumbers.length == 0)
    {
        return;
    }
    
    NSArray *listItems = [phoneNumbers componentsSeparatedByString:@","];
    
    if (listItems.count == 1)
    {
        //Make call
        NSLog(@"Making Call to %@", listItems[0]);
        [self phoneCallNumber:listItems[0]];
    }
    else if (listItems.count > 1)
    {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Call Number" message:@"Which phone number would you like to call?" preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            // Cancel button tappped.
            //[self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        for (NSString *phoneNumber in listItems) {

            NSString *phoneNumberTrimmed = [Utils getTrimmedString:phoneNumber];
            
            [actionSheet addAction:[UIAlertAction actionWithTitle:phoneNumberTrimmed style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                NSLog(@"Making Call to %@", phoneNumber);
                [self phoneCallNumber:phoneNumber];
                
            }]];
            
        }
        
        // Present action sheet.
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    
}


- (IBAction)showReportForm:(id)sender {

    [self performSegueWithIdentifier:@"ReportSegue" sender:nil];
    
}


- (IBAction)donePressed:(id)sender {

    [self.delegate doneSelectedDetails];
}


#pragma mark -
#pragma mark Private methods
-(void)phoneCallNumber : (NSString *)phoneNumber
{
    NSString *newPhoneOnlyNumbers = [[phoneNumber componentsSeparatedByCharactersInSet:
                                     [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                                     componentsJoinedByString:@""];

    NSLog(@"Calling %@", newPhoneOnlyNumbers);
    
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",newPhoneOnlyNumbers]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        
        [[UIApplication sharedApplication] openURL:phoneUrl];
    }
    else
    {
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Call facility is not available in your device. Please copy paste the number and try calling manually." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
    
}




#pragma mark -
#pragma mark Seque stuff

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ReportSegue"])
    {
        UINavigationController *navVC = (UINavigationController *) segue.destinationViewController;
        ReportUsViewController *detailVC = (ReportUsViewController *) navVC.topViewController;
        detailVC.stationDetails = self.station;
        detailVC.delegate = self;
    }
}

#pragma mark -
#pragma mark ReportUs Delegate
-(void)closeReport
{
    [self dismissViewControllerAnimated:YES completion:NO];
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
