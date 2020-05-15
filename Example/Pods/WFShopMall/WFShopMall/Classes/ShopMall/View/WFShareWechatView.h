//
//  WFShareWechatView.h
//  WFKit
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShareWechatView : UIView <UIGestureRecognizerDelegate>
/// 商品信息
@property (nonatomic, strong) NSDictionary *dict;
/// 初始化
+ (WFShareWechatView *)shareInstace;


@end

NS_ASSUME_NONNULL_END
