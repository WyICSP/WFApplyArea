//
//  WFNewUserHeadView.h
//  WFKit
//
//  Created by 王宇 on 2020/3/30.
//  Copyright © 2020 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFUserCenterModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFNewUserHeadView : UIView
/// 用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
/// 用户名字
@property (weak, nonatomic) IBOutlet UILabel *name;
/// 用户电话
@property (weak, nonatomic) IBOutlet UILabel *phone;
/// 套餐到期时间
@property (weak, nonatomic) IBOutlet UILabel *meal;
///  充值按钮
@property (weak, nonatomic) IBOutlet UIButton *rechargeBtn;
/// 余额
@property (weak, nonatomic) IBOutlet UILabel *balance;
/// vipView
@property (weak, nonatomic) IBOutlet UIView *vipView;
/// 背景图
@property (weak, nonatomic) IBOutlet UIImageView *balanceBgImg;
/// 赋值
@property (strong, nonatomic) WFUserCenterModel *model;
/// 充值
@property (copy, nonatomic) void(^rechargeBlock)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
