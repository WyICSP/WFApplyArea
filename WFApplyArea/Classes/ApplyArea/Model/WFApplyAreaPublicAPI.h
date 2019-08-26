//
//  WFApplyAreaPublicAPI.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaPublicAPI : NSObject

/**
 打开片区申请页面
 */
+ (void)openApplyAreaCtrlWithController:(UIViewController *)controller;

/**
 开发我的片区页面
 
 @param controller 上一个页面
 */
+ (void)openMyChargePileCtrlWithController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END