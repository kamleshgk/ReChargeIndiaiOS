//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"
#import "ChargingStation.h"


@protocol MessageDelegate

-(void)closeComments:(BOOL) reloadComments;

@end

@interface MessageViewController : SLKTextViewController
{
    ChargingStation *station;
    NSMutableArray *commentList;
    BOOL dataChanged;
    
}

@property (weak, nonatomic) id <MessageDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, strong) ChargingStation *station;

@end
