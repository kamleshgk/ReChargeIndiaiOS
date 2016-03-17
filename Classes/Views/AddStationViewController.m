//
//  AddStationViewController.h
//
// Copyright (c) 2014. All rights reserved.
//


#import "AddStationViewController.h"
#import "SWRevealViewController.h"
#import "UserSessionInfo.h"
#import "Utils.h"

@implementation AddStationViewController

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
    
    [self clearStuff];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:emailTextField action:@selector(resignFirstResponder)];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    emailTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nameTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    nameTextField.inputAccessoryView = toolbar;

    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:addressTextView action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    addressTextView.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:NoChargePointsTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    NoChargePointsTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:timingTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    timingTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:phoneTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    phoneTextField.inputAccessoryView = toolbar;

    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:costTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    costTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:compatibilityTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    compatibilityTextField.inputAccessoryView = toolbar;
    
    barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:infoTextField action:@selector(resignFirstResponder)];
    toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.items = [NSArray arrayWithObjects: flex, flex, barButton, nil];
    infoTextField.inputAccessoryView = toolbar;
    
    CGRect scrollFrame = scrollView.frame;
    [contentView setFrame:scrollFrame];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height + 500)];
    
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
    emailTextField.text = @"";
    nameTextField.text = @"";
    addressTextView.text = @"";
    NoChargePointsTextField.text = @"";
    timingTextField.text = @"";
    phoneTextField.text = @"";
    costTextField.text = @"";
    compatibilityTextField.text = @"";
    infoTextField.text = @"";
}

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


- (IBAction)SendEmail:(id)sender {

    [emailTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [addressTextView resignFirstResponder];
    [NoChargePointsTextField resignFirstResponder];
    [timingTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [costTextField resignFirstResponder];
    [compatibilityTextField resignFirstResponder];
    [infoTextField resignFirstResponder];

    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([[Utils getTrimmedString:emailTextField.text] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter an email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([emailTest evaluateWithObject:[Utils getTrimmedString:emailTextField.text]] == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter a valid email address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:nameTextField.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the name of the charge point." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:addressTextView.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:NoChargePointsTextField.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the number of points available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:timingTextField.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the availability time of the charge point." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:phoneTextField.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the contact number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    else if ([[Utils getTrimmedString:costTextField.text]isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Validation" message:@"Please enter the costing details." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSString *body = [NSString stringWithFormat: @"Hello ReCharge India, \n I would like to create a community charge point. "
                                                 @"Here are the details. \n\n Email - %@ \n Charge Point Unique Name - %@ \n Address - \n%@ \n\n No. of Charge Points - %@ \n "
                                                 @"Timings - %@ \n Phone - %@ \n Cost - %@ \n\n ChargePoint Compatibility - \n%@ \n\n Additional Information - \n%@",
                                                 [Utils getTrimmedString:emailTextField.text], [Utils getTrimmedString:nameTextField.text],
                                                 [Utils getTrimmedString:addressTextView.text], [Utils getTrimmedString:NoChargePointsTextField.text],
                                                 [Utils getTrimmedString:timingTextField.text], [Utils getTrimmedString:phoneTextField.text],
                                                 [Utils getTrimmedString:costTextField.text], [Utils getTrimmedString:compatibilityTextField.text],
                                                 [Utils getTrimmedString:infoTextField.text]];
    
    // Localized
    NSString *recipients = @"mailto:kamlesh@pluginindia.com?cc=damnish.kumar@hytechpro.com,ranjanray@gmail.com&subject=I want to add a community charge point!";
    
    NSString *bodyStr = [NSString stringWithFormat:@"&body= %@", body];
    
    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, bodyStr];
    
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    
    [self clearStuff];
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
