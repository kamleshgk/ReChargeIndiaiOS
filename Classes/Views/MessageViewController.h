//
//  MessageViewController.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 8/15/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "SLKTextViewController.h"

@protocol MessageDelegate

-(void)closeComments;

@end

@interface MessageViewController : SLKTextViewController
{
    NSMutableArray *commentList;
    
}

@property (weak, nonatomic) id <MessageDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *commentList;

@end
