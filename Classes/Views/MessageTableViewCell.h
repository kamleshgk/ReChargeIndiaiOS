//
//  MessageTableViewCell.h
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MessageCellDelegate

-(void)updateCommentReaction:(NSIndexPath *) indexPath;

@end

static CGFloat kMessageTableViewCellMinimumHeight = 50.0;
static CGFloat kMessageTableViewCellAvatarHeight = 30.0;

static NSString *MessengerCellIdentifier = @"MessengerCell";
static NSString *AutoCompletionCellIdentifier = @"AutoCompletionCell";

@interface MessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *bodyLabel;
@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *dateStringLabel;
@property (nonatomic, strong) UIImageView *thumbsView;

@property (weak, nonatomic) id <MessageCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic) BOOL usedForMessage;

+ (CGFloat)defaultFontSize;

@end
