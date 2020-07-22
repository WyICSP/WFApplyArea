//
//  WFNewUserHeadView.m
//  WFKit
//
//  Created by 王宇 on 2020/3/30.
//  Copyright © 2020 王宇. All rights reserved.
//

#import "WFNewUserHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WFUserCenterModel.h"
#import "WKHelp.h"

@implementation WFNewUserHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.vipView.layer.shadowOpacity = 0.45;// 阴影透明度
    self.vipView.layer.shadowColor = UIColorFromRGB(0XE4E4E4).CGColor;// 阴影的颜色
    self.vipView.layer.shadowRadius = 5;// 阴影扩散的范围控制
    self.vipView.layer.shadowOffset  = CGSizeMake(1, 1);// 阴影的范围
    self.vipView.layer.cornerRadius = 10.0f;
    self.rechargeBtn.layer.cornerRadius = 17.5f;
    self.balanceBgImg.layer.cornerRadius = 10.0f;
    self.userPhoto.layer.cornerRadius = 30.0f;
    
    // 添加手势 用户头像
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userPhoneEvent:)];
    [self.userPhoto addGestureRecognizer:tap];
    
    // 钱包模块
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(balanceEvent:)];
    [self.balanceBgImg addGestureRecognizer:tap1];
    
    // 套餐
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipEvent:)];
    [self.vipView addGestureRecognizer:tap2];
}

// 充值
- (IBAction)clickBtn:(id)sender {
    !self.rechargeBlock ? : self.rechargeBlock(10);
}


// 头像
- (void)userPhoneEvent:(UITapGestureRecognizer *)sender {
    !self.rechargeBlock ? : self.rechargeBlock(40);
}

// 钱包
- (void)balanceEvent:(UITapGestureRecognizer *)sender {
    !self.rechargeBlock ? : self.rechargeBlock(60);
}


// vip
- (void)vipEvent:(UITapGestureRecognizer *)sender {
    !self.rechargeBlock ? : self.rechargeBlock(40);
}

- (void)setModel:(WFUserCenterModel *)model {
    // 头像
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"new_default_photo"]];
    // 昵称
    self.name.text = model.nickname.length == 0 ? @"默认昵称" : model.nickname;
    // 手机号
    self.phone.text = model.mobile;
    // 余额
    self.balance.text = model.price;
}


@end
