//
//  vipertestDBController.h
//
// Copyright (c) 2014. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "DatabaseController.h"


@protocol DBDelegate;

@interface vipertestDBController : NSObject
{
    DatabaseController *dbController;
    
}

@property (nonatomic, weak) id <DBDelegate> delegate;


- (BOOL) getAllContacts;

- (BOOL)createContacts : (NSMutableArray *)newContacts;


@end


@protocol DBDelegate <NSObject>

-(void)dbDataSuccessCallback:(vipertestDBController *)dbService
                              returnData:(NSMutableArray *)data
                              operation:(NSString *)operation;

-(void)dbFailureCallback:(vipertestDBController *)dbService
                         returnError:(NSString *)errorDescription
                         operation:(NSString *)operation;


@end

