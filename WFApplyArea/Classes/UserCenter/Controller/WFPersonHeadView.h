//
//  WFPersonHeadView.h
//  WFBusSchool_Example
//
//  Created by 王宇 on 2020/4/22.
//  Copyright © 2020 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFUserCenterModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFPersonHeadView : UIView
/// 头部 view
@property (weak, nonatomic) IBOutlet UIView *topView;
///  底部 view
@property (weak, nonatomic) IBOutlet UIView *bottomView;
///  图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/// 名字
@property (weak, nonatomic) IBOutlet UILabel *name;
/// 手机号
@property (weak, nonatomic) IBOutlet UILabel *phone;
/// 内容 view
@property (weak, nonatomic) IBOutlet UIView *infoView;
/// 头部 view 高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
/// 余额
@property (weak, nonatomic) IBOutlet UILabel *banlance;

/// 点击事件
@property (copy, nonatomic) void (^clickEventBlock)(NSInteger tag);
/// 赋值
@property (strong, nonatomic) WFUserCenterModel *model;
@end

NS_ASSUME_NONNULL_END
