//
//  AboutViewController.m
//
//  Copyright (c) 2016. All rights reserved.

#import "AboutViewController.h"
#import "SWRevealViewController.h"
#import "Utils.h"


@implementation AboutViewController

@synthesize webView, contentFlag;

#pragma mark -
#pragma mark View Did Load/Unload

-(void)viewDidLoad
{
   [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;    

    // This is key for catching link calls in the web view
    webView.delegate = self;
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
    
    [self addSideMenuAction];
    
    [activity setHidesWhenStopped:YES];
    
    // Set up web view content from external HTML file
    NSURL *websiteUrl;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

    if (contentFlag == AddCommunityStation)
    {
        item.title = @"Add Community Station";
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"addcommunitystation" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        //websiteUrl = [NSURL URLWithString:@"http://www.pluginindia.com/addcommunitystation.html"];
    }
    else if (contentFlag == FAQ)
    {
        //websiteUrl = [NSURL URLWithString:@"http://www.pluginindia.com/communitystationfaq.html"];
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"communitystationfaq" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        item.title = @"FAQ";
    }
    else if (contentFlag == AboutUs)
    {
        NSString * version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
        NSString * build = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
        
        NSString * versionBuild = [NSString stringWithFormat: @"v%@", version];
        
        if (![version isEqualToString: build]) {
            versionBuild = [NSString stringWithFormat: @"About App  %@(%@)", versionBuild, build];
        }
        
        item.title = versionBuild;
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"aboutus" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        //websiteUrl = [NSURL URLWithString:@"http://www.pluginindia.com/aboutrelive.html"];
    }
    else if (contentFlag == Privacy)
    {
        item.title = @"Privacy";
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"appprivacypolicy" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        //websiteUrl = [NSURL URLWithString:@"http://www.pluginindia.com/appprivacypolicy.html"];
    }
    else if (contentFlag == Terms)
    {
        item.title = @"Terms and Conditions";
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"appterms" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [webView loadHTMLString:htmlString baseURL:nil];
        
        //websiteUrl = [NSURL URLWithString:@"http://www.pluginindia.com/appterms.html"];
    }
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
    
    webView.opaque = NO;
    webView.backgroundColor = [UIColor clearColor];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activity startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activity stopAnimating];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
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

// Catch web view links and have them open in Mobile Safari rather than in the web view
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
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
