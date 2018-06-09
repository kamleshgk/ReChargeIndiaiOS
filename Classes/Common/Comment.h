//
// Comment.h
//
// Copyright (c) 2018. All rights reserved.

#import <Foundation/Foundation.h>

@interface Comment : NSObject
{
    NSString*   commentId;
    NSString*   userName;
    NSString*   comment;
    long date;
    bool reaction;
}

@property (nonatomic, retain)     NSString*   commentId;
@property (nonatomic, retain)     NSString*   userName;
@property (nonatomic, retain)     NSString*   comment;
@property (nonatomic, assign)     long date;
@property (nonatomic, assign)     bool reaction;

@end

