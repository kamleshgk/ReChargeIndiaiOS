//
//  ChargingStationDetailsViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "ChargingStationDetailsViewController.h"
#import "UserSessionInfo.h"
#import "ChargingStationPresenter.h"
#import "Utils.h"
#import "Comment.h"
#import "WSService.h"

@implementation ChargingStationDetailsViewController

@synthesize station;

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, 1500)];
    self.automaticallyAdjustsScrollViewInsets = NO;

    commentCountLabel.text = [NSString stringWithFormat:@"0 Positive\n0 Negative"];
    totalCommentCountLabel.text = @"0";
    
    commentObjectList = [NSMutableArray alloc];

    [self loadCommentData];
    
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
        chargingTypeImageView.image = [UIImage imageNamed:@"communityBus"];
    }
    else if (chargeStationType == 2)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"mahindra"];
    }
    else if (chargeStationType == 3)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"ather"];
    }
    else if (chargeStationType == 4)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"communityHome"];
    }
    else if (chargeStationType == 5)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"fastCharger"];
    }
    else if (chargeStationType == 6)
    {
        chargingTypeImageView.image = [UIImage imageNamed:@"sun"];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}


#pragma mark -
#pragma mark Handlers


- (IBAction)viewComments:(id)sender {
    
    [self performSegueWithIdentifier:@"CommentsSegue" sender:nil];
    
}

- (IBAction)shareChargePoint:(id)sender {
    
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


-(void) loadCommentData
{
    activityGuy.hidden = YES;
    commentButton.enabled = NO;
    
    if (![WSService checkInternet:NO])
    {
        [WSService showNetworkAlertWith:@"Could not load comment data. Please check your data connection."];
        [super viewDidLoad];
        return;
    }
    UserSessionInfo *userSession = [UserSessionInfo sharedUser];
    ChargingStationPresenter *presentor = userSession.dependencies.chargingStationPresenter;

    activityGuy.hidden = NO;
    [activityGuy startAnimating];
    commentButton.enabled = NO;
    [presentor getAllCommentsForStationId:station.stationid completion:^(NSMutableArray *commentList, NSError *error) {
        
        NSString *commentCount = [NSString stringWithFormat:@"%lu", (unsigned long)commentList.count];
        
        int numberOfPositiveComments = 0;
        int numberOfNegativeComments = 0;
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        NSArray *sortedArray = [commentList sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        commentObjectList = [sortedArray mutableCopy];
        for(Comment *commentItem in commentList)
        {
            if (commentItem.reaction == YES)
            {
                numberOfPositiveComments++;
            }
            else
            {
                numberOfNegativeComments++;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            //Send pets data into our main thread
            commentCountLabel.numberOfLines = 0;
            NSString *likeDislikeString = [NSString stringWithFormat:@"%d Positive\n%d Negative", numberOfPositiveComments, numberOfNegativeComments];
            commentCountLabel.text = likeDislikeString;
            totalCommentCountLabel.text = commentCount;
            [activityGuy stopAnimating];
            activityGuy.hidden = YES;
            commentButton.enabled = YES;
        });
    }];
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
    else if ([segue.identifier isEqualToString:@"CommentsSegue"])
    {
        UINavigationController *navVC = (UINavigationController *) segue.destinationViewController;
        MessageViewController *mainVC = (MessageViewController *) navVC.topViewController;
        mainVC.commentList = commentObjectList;
        mainVC.station = station;
        mainVC.delegate = self;
    }
}

#pragma mark -
#pragma mark ReportUs Delegate
-(void)closeReport
{
    [self dismissViewControllerAnimated:YES completion:NO];
}

#pragma mark -
#pragma mark Messages Delegate
-(void)closeComments:(BOOL) reloadComments
{
    if (reloadComments == YES)
    {
        [self loadCommentData];
    }
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
