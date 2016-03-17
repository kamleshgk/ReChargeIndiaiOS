//
//  WSService.h
//
//
// Copyright (c) 2014. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@protocol WSServiceDelegate;

//The main object that talks to the Web APIs
@interface WSService : NSObject
{
    AFHTTPSessionManager *manager;
}

@property (nonatomic, weak) id <WSServiceDelegate> delegate;
@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (WSService *)sharedWSServiceInstance;

- (void) getTestRESTCalls;

- (void) getTestRESTCallsForSingleRecord;

+(BOOL)checkInternet: (BOOL)validURL;
+(void)showNetworkAlert;

@end



@protocol WSServiceDelegate <NSObject>

-(void)wsServiceSuccessCallback:(WSService *)service
                     returnData:(id)data
                     operation:(NSString *)operation;

-(void)wsServiceFailureCallback:(WSService *)service
                    returnError:(NSString *)errorDescription
                    operation:(NSString *)operation;

@end
