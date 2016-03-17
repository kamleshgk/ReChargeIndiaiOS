//
//  ManagerBase.h
//  viperTest
//
//  Created by kamyFCMacBook on 7/9/15.
//
//

#import <Foundation/Foundation.h>

@protocol ManagerDelegate <NSObject>

-(void)SuccessCallback:(id)data
                         operation:(NSString *)operation;

-(void)FailureCallback:(NSString *)errorDescription
                         operation:(NSString *)operation;


@end
