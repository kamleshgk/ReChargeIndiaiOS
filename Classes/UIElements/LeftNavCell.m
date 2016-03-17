//
//
// Copyright (c) 2014. All rights reserved.
//


#import "LeftNavCell.h"
#import "UserSessionInfo.h"

@implementation LeftNavCell

@synthesize imageName, menuItemName;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void) render
{
    //Show comments
    self.menuName.text = menuItemName;
    self.menuImage.image = [UIImage imageNamed:imageName];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [record.circleView setNeedsDisplayInRect:record.circleView.frame];
}*/


@end
