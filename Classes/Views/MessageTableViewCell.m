//
//  MessageTableViewCell.m
//  Messenger
//
//  Created by Ignacio Romero Zurbuchen on 9/1/14.
//  Copyright (c) 2014 Slack Technologies, Inc. All rights reserved.
//

#import "MessageTableViewCell.h"
#import "SLKUIConstants.h"

@implementation MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        [self configureSubviews];
    }
    return self;
}

- (void)configureSubviews
{
    [self.contentView addSubview:self.thumbnailView];
    [self.contentView addSubview:self.thumbsView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dateStringLabel];
    [self.contentView addSubview:self.bodyLabel];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [_thumbsView addGestureRecognizer:tapRecognizer];

    NSDictionary *views = @{@"thumbnailView": self.thumbnailView,
                            @"thumbsView": self.thumbsView,
                            @"titleLabel": self.titleLabel,
                            @"dateStringLabel": self.dateStringLabel,
                            @"bodyLabel": self.bodyLabel,
                            };
    
    NSDictionary *metrics = @{@"tumbSize": @(kMessageTableViewCellAvatarHeight),
                              @"padding": @60,
                              @"right": @10,
                              @"left": @5
                              };

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-right-[thumbnailView(tumbSize)]-(>=0)-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-right-[thumbsView(tumbSize)]-right-|" options:0 metrics:metrics views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[thumbnailView(tumbSize)]-right-[titleLabel(>=0)]-right-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[thumbsView]-5-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[thumbnailView(tumbSize)]-right-[dateStringLabel(>=0)]-right-|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-left-[thumbnailView(tumbSize)]-right-[bodyLabel(>=0)]-right-|" options:0 metrics:metrics views:views]];
    
    if ([self.reuseIdentifier isEqualToString:MessengerCellIdentifier]) {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-right-[titleLabel(20)]-[dateStringLabel(15)]-left-[bodyLabel(>=0@999)]-left-|" options:0 metrics:metrics views:views]];
    }
    else {
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:metrics views:views]];
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat pointSize = [MessageTableViewCell defaultFontSize];
    
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    self.bodyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:pointSize];
    
    self.titleLabel.text = @"";
    self.bodyLabel.text = @"";

}

- (IBAction)tapAction:(id)sender {
    
    [self.delegate updateCommentReaction:self.indexPath];
}


#pragma mark - Getters

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.userInteractionEnabled = NO;
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    }
    return _titleLabel;
}

- (UILabel *)bodyLabel
{
    if (!_bodyLabel) {
        _bodyLabel = [UILabel new];
        _bodyLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _bodyLabel.backgroundColor = [UIColor clearColor];
        _bodyLabel.userInteractionEnabled = NO;
        _bodyLabel.numberOfLines = 0;
        _bodyLabel.textColor = [UIColor blackColor];
        _bodyLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    }
    return _bodyLabel;
}

- (UILabel *)dateStringLabel
{
    if (!_dateStringLabel) {
        _dateStringLabel = [UILabel new];
        _dateStringLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _dateStringLabel.backgroundColor = [UIColor clearColor];
        _dateStringLabel.userInteractionEnabled = NO;
        _dateStringLabel.numberOfLines = 0;
        _dateStringLabel.textColor = [UIColor grayColor];
        _dateStringLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10];
    }
    return _dateStringLabel;
}

- (UIImageView *)thumbsView
{
    if (!_thumbsView) {
        _thumbsView = [UIImageView new];
        _thumbsView.translatesAutoresizingMaskIntoConstraints = NO;
        _thumbsView.userInteractionEnabled = YES;
        _thumbsView.image = [UIImage imageNamed:@"up.png"];
        
        _thumbsView.layer.cornerRadius = kMessageTableViewCellAvatarHeight/2.0;
        _thumbsView.layer.masksToBounds = YES;
    }
    return _thumbsView;
}

- (UIImageView *)thumbnailView
{
    if (!_thumbnailView) {
        _thumbnailView = [UIImageView new];
        _thumbnailView.translatesAutoresizingMaskIntoConstraints = NO;
        _thumbnailView.userInteractionEnabled = NO;
        _thumbnailView.image = [UIImage imageNamed:@"person.png"];
        
        _thumbnailView.layer.cornerRadius = kMessageTableViewCellAvatarHeight/2.0;
        _thumbnailView.layer.masksToBounds = YES;
    }
    return _thumbnailView;
}

+ (CGFloat)defaultFontSize
{
    CGFloat pointSize = 13.0;
    
    NSString *contentSizeCategory = [[UIApplication sharedApplication] preferredContentSizeCategory];
    pointSize += SLKPointSizeDifferenceForCategory(contentSizeCategory);
    
    return pointSize;
}

@end
