//
//
// Copyright (c) 2014. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface LeftNavCell : UITableViewCell
{
    NSString *menuItemName;
    NSString *imageName;
}

@property (nonatomic, strong) IBOutlet UILabel *menuName;
@property (nonatomic, strong) IBOutlet UIImageView *menuImage;
@property (nonatomic, copy) NSString *menuItemName;
@property (nonatomic, copy) NSString *imageName;

- (void) render;

@end
