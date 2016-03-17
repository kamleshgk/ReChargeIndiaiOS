//
//  ReportUsViewController.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "ReportUsViewController.h"
#import "UserSessionInfo.h"
#import "Utils.h"

@implementation ReportUsViewController

@synthesize stationDetails;

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
    [self clearStuff];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nameTextField action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    nameTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:phoneTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    phoneTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:reportTextView action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    reportTextView.inputAccessoryView = toolbar;
    
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

-(void) clearStuff
{
    nameTextField.text = @"";
    reportTextView.text = @"";
    phoneTextField.text = @"";
}

#pragma mark - IBButton Handlers

- (IBAction)CloseAndQuit:(id)sender {

    [self.delegate closeReport];
}

- (IBAction)SendEmailAndQuit:(id)sender {

    [nameTextField resignFirstResponder];
    [reportTextView resignFirstResponder];
    [phoneTextField resignFirstResponder];

    if ([[Utils getTrimmedString:nameTextField.text] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter your name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:phoneTextField.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter your contact phone number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:reportTextView.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the report." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *body = [NSString stringWithFormat: @"Hello ReCharge India, \n I would like to report a community charge point. "
                                                 @"Here are the details. \n\n Charge Point Name - \n%@ \n\n My Name - \n%@ \n My Phone - \n%@ \n "
                                                 @"Report - \n%@",
                                                 stationDetails.name,
                                                 [Utils getTrimmedString:nameTextField.text], [Utils getTrimmedString:phoneTextField.text],
                                                 [Utils getTrimmedString:reportTextView.text]];
    
    // Localized
    NSString *recipients = @"mailto:kamlesh@pluginindia.com?cc=damnish.kumar@hytechpro.com,ranjanray@gmail.com&subject=Reporting a community charge point";
    
    NSString *bodyStr = [NSString stringWithFormat:@"&body= %@", body];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, bodyStr];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
    [self.delegate closeReport];
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
