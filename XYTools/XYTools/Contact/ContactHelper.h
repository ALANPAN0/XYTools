//
//  ContactHelper.h
//  XYTools
//
//  Created by Panda on 16/3/16.
//  Copyright © 2016年 Panda. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIViewController;
@interface ContactHelper : NSObject

- (void)showInController:(UIViewController *)vc completion:(void(^)(NSDictionary *))block;

@end
