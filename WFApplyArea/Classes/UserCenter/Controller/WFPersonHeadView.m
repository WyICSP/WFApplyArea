//
//  WFPersonHeadView.m
//  WFBusSchool_Example
//
//  Created by 王宇 on 2020/4/22.
//  Copyright © 2020 wyxlh. All rights reserved.
//

#import "WFPersonHeadView.h"
#import "WFUserCenterModel.h"
#import "NSString+Regular.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WKConfig.h"

@implementation WFPersonHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bottomView.layer.cornerRadius = 10.0f;
    self.imgView.layer.cornerRadius = 30.0f;
    self.topCons.constant = NavHeight;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickView:)];
    [self.bottomView addGestureRecognizer:tap];
    
    // 头像
    UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
    [self.imgView addGestureRecognizer:imgTap];
}

/// 10 客服 20 消息 30 设置 40 个人资料
- (IBAction)clickBtn:(UIButton *)sender {
    !self.clickEventBlock ? : self.clickEventBlock(sender.tag);
}

- (void)clickView:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.bottomView];
    if (point.x < (ScreenWidth-30)/2) {
        //充点券
        !self.clickEventBlock ? : self.clickEventBlock(50);
    }else {
        // 钱包
        !self.clickEventBlock ? : self.clickEventBlock(60);
    }
}

- (void)clickImage:(UITapGestureRecognizer *)sender {
    // 头像
    !self.clickEventBlock ? : self.clickEventBlock(70);
}

- (void)setModel:(WFUserCenterModel *)model {
    self.phone.text = [NSString getNullOrNoNull:model.mobile];
    self.name.text = [NSString getNullOrNoNull:model.nickname];
    self.banlance.text = [NSString stringWithFormat:@"%@",[NSString decimalNumberWithDouble:model.price.doubleValue/1000]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"fang"]];
}


@end
