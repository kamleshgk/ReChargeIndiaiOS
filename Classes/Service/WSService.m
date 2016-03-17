//
//  WSService.m
//
// Copyright (c) 2014. All rights reserved.
//


#import "WSService.h"
#import "Reachability.h"
#import "UserSessionInfo.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "Utils.h"


static NSString *NO_NETWORK = @"NoNetwork";

static NSString *WEB_API_SERVER = @"https://localhost";
static NSString *WEB_API_SERVER_TEST = @"http://jsonplaceholder.typicode.com";
static NSString *WEB_API_SERVERPORT = @"443";


static NSString *WEB_API_GET_TEST_DATA = @"get-test-data";
static NSString *WEB_API_GET_TEST_DATA_RESPONSE = @"get-test-data-response";

static NSString *WEB_API_GET_TEST_SINGLE_DATA = @"get-test-single-data";
static NSString *WEB_API_GET_TEST_DATA_SINGLE_RESPONSE = @"get-test-single-data-response";

//Out Singleton instance of WSService.
static WSService *sharedWSServiceInstance = nil;


@implementation WSService

@synthesize delegate, manager;

- (id) init {
	if ( self = [super init] )
    {
        [self configureAFNetworking];
	}
	return self;
}

- (void) configureAFNetworking
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:WEB_API_SERVER_TEST];
    
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    AFSecurityPolicy *sec=[[AFSecurityPolicy alloc] init];
    [sec setAllowInvalidCertificates:YES];
    manager.securityPolicy=sec;
}


- (void) getTestRESTCalls
{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:@"/posts" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSArray *posts = (NSArray *)responseObject;
        
        for (NSDictionary *itemD in posts)
        {
            NSString *value = itemD[@"title"];
            NSLog(@"%@", value);
        }
        
        [delegate wsServiceSuccessCallback:self returnData:posts operation:WEB_API_GET_TEST_DATA_RESPONSE];
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [delegate wsServiceFailureCallback:self returnError:@"Error Retrieving TestData" operation:WEB_API_GET_TEST_DATA_RESPONSE];
    }];
}

- (void) getTestRESTCallsForSingleRecord
{
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager GET:@"/posts/7" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         NSDictionary *post = (NSDictionary *)responseObject;
         
         [delegate wsServiceSuccessCallback:self returnData:post operation:WEB_API_GET_TEST_SINGLE_DATA];
     }
         failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [delegate wsServiceFailureCallback:self returnError:@"Error Retrieving TestData for single record" operation:WEB_API_GET_TEST_DATA_SINGLE_RESPONSE];
     }];
}

- (void) dealloc {



}
	 

#pragma mark -
#pragma mark Checking Internet Connection

+(BOOL)checkInternet: (BOOL)validURL
{
	//Test for Internet Connection
	NSLog(@"Testing Internet Connectivity");
	BOOL internet;
	
	NSString *storedSiteURL = @"";
	storedSiteURL = @"www.google.com";
		
	Reachability *r = [Reachability reachabilityWithHostName:storedSiteURL];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) 
	{
		internet = NO;
	} 
	else 
	{
		internet = YES;
	}
	return internet;
}

+(void)showNetworkAlert
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Internet unavailable: Check wi-fi or data network." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}


#pragma mark -
#pragma mark Singleton Methods
+ (WSService *)sharedWSServiceInstance {
	if(sharedWSServiceInstance == nil){
		sharedWSServiceInstance = [[super allocWithZone:NULL] init];
	}
	return sharedWSServiceInstance;
}
+ (id)allocWithZone:(NSZone *)zone {
	return [self sharedWSServiceInstance];
}
- (id)copyWithZone:(NSZone *)zone {
	return self;
}


@end 
