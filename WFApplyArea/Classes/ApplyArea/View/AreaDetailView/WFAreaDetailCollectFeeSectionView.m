//
//  WFAreaDetailCollectFeeSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailCollectFeeSectionView.h"
#import "WFAreaDetailModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"
#import "WYHead.h"

@implementation WFAreaDetailCollectFeeSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置圆角
    self.contentsView.backgroundColor = UIColor.clearColor;
    [self.contentsView setRounderCornerWithRadius:10.0f rectCorner:WFRadiusRectCornerTopLeft | WFRadiusRectCornerTopRight imageColor:UIColor.whiteColor size:CGSizeMake(ScreenWidth-24.0f, KHeight(95.0f))];
    //设置 button
    for (UIButton *btn in self.btns) {
        btn.layer.cornerRadius = [self constraintWithHeight:30.0f]/2;
    }
    self.formBtn.layer.cornerRadius = self.formBtn.height/2;
    self.formBtn.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
    self.formBtn.layer.borderWidth = 0.5;
}


/**
 按钮点击事件

 @param sender 10 查看功率计次表, 20 去编辑 30 单次收费 40 多次收费 50 优惠收费
 */
- (IBAction)clickBtn:(UIButton *)sender {
    //点击事件
    !self.clickBtnBlock ? : self.clickBtnBlock(sender.titleLabel.text);
}

/**
 功率计次表 和编辑

 @param sender 10 查看功率计次表, 20 去编辑
 */
- (IBAction)clickOtherBtn:(UIButton *)sender {
    !self.clickBtnBlock ? : self.clickBtnBlock(sender.titleLabel.text);
}

- (void)setModel:(WFAreaDetailModel *)model {
    _model = model;
    NSMutableArray *titles = [NSMutableArray new];

    //查看有无单次收费
    if (self.model.singleCharge.singleChargeId.length != 0) {
        [titles addObject:@"单次收费"];
        self.model.isHaveSinge = YES;
    }
    //查看有无多次收费
    if (self.model.multipleChargesList.count != 0) {
        [titles addObject:@"多次收费"];
        self.model.isHaveManyTime = YES;
    }
    //查看优惠收费
    if (self.model.vipCharge.vipChargeId.length != 0) {
        [titles addObject:@"优惠收费"];
        self.model.isHaveVip = YES;
    }
    
    //设置按钮 统一收费的时候是不显示的
    if (self.model.singleCharge.isSelect) {
        [self.formBtn setTitle:@"  利润计算表  " forState:0];
        self.formBtn.hidden = self.model.singleCharge.chargeType == 0;
    }else if (self.model.isSelectMany) {
        if (self.model.multipleChargesList.count != 0) {
            WFAreaDetailMultipleModel *mModel = [self.model.multipleChargesList firstObject];
            self.formBtn.hidden = mModel.chargeType == 0;
        }
        [self.formBtn setTitle:@"  功率计次表  " forState:0];
    }else if (self.model.vipCharge.isSelect) {
        self.formBtn.hidden = NO;
        [self.formBtn setTitle:@"  查看会员  " forState:0];
    }
    
    //显示效果
    if (titles.count == 1) {
        [self.leftBtn setTitle:[titles firstObject] forState:0];
        self.leftBtn.backgroundColor = NavColor;
        self.leftBtn.hidden = NO;
        [self.leftBtn setTitleColor:UIColor.whiteColor forState:0];
    }else if (titles.count == 2) {
        self.leftBtn.hidden = self.centerBtn.hidden = NO;
        [self.leftBtn setTitle:[titles firstObject] forState:0];
        [self.centerBtn setTitle:[titles lastObject] forState:0];
        
        //如果选中的是
        if (self.model.isHaveSinge && self.model.isHaveManyTime) {
            //如果设置了单次收费 和多次收费两种
            if (self.model.singleCharge.isSelect) {
                self.leftBtn.backgroundColor = NavColor;
                [self.leftBtn setTitleColor:UIColor.whiteColor forState:0];
                self.centerBtn.backgroundColor = UIColor.whiteColor;
                [self.centerBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
            }else if (self.model.isSelectMany) {
                self.leftBtn.backgroundColor = UIColor.whiteColor;
                [self.leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
                self.centerBtn.backgroundColor = NavColor;
                [self.centerBtn setTitleColor:UIColor.whiteColor forState:0];
            }
        }else if (self.model.isHaveSinge && self.model.isHaveVip) {
            //如果设置了单次收费和优惠收费两种
            if (self.model.singleCharge.isSelect) {
                self.leftBtn.backgroundColor = NavColor;
                [self.leftBtn setTitleColor:UIColor.whiteColor forState:0];
                
                self.centerBtn.backgroundColor = UIColor.whiteColor;
                [self.centerBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
            }else if (self.model.vipCharge.isSelect) {
                self.leftBtn.backgroundColor = UIColor.whiteColor;
                [self.leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
                self.centerBtn.backgroundColor = NavColor;
                [self.centerBtn setTitleColor:UIColor.whiteColor forState:0];
            }
        }else if (self.model.isHaveManyTime && self.model.isHaveVip) {
            //如果设置了优惠收费和多次收费
            if (self.model.isSelectMany) {
                self.leftBtn.backgroundColor = NavColor;
                [self.leftBtn setTitleColor:UIColor.whiteColor forState:0];
                self.centerBtn.backgroundColor = UIColor.whiteColor;
                [self.centerBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
            }else if (self.model.vipCharge.isSelect) {
                self.leftBtn.backgroundColor = UIColor.whiteColor;
                [self.leftBtn setTitleColor:UIColorFromRGB(0x333333) forState:0];
                self.centerBtn.backgroundColor = NavColor;
                [self.centerBtn setTitleColor:UIColor.whiteColor forState:0];
            }
        }

    }else if (titles.count == 3) {
        for (int i = 0 ; i < 3; i++) {
            UIButton *btn = self.btns[i];
            btn.hidden = NO;
            [btn setTitle:titles[i] forState:0];
            if (self.model.singleCharge.isSelect) {
                //单次收费
                [btn setTitleColor:i == 0 ? UIColor.whiteColor : UIColorFromRGB(0x333333) forState:0];
                btn.backgroundColor = i == 0 ? NavColor : UIColor.whiteColor;
            }else if (self.model.isSelectMany) {
                //多次收费
                [btn setTitleColor:i == 1 ? UIColor.whiteColor : UIColorFromRGB(0x333333) forState:0];
                btn.backgroundColor = i == 1 ? NavColor : UIColor.whiteColor;
            }else if (self.model.vipCharge.isSelect) {
                //优惠收费
                [btn setTitleColor:i == 2 ? UIColor.whiteColor : UIColorFromRGB(0x333333) forState:0];
                btn.backgroundColor = i == 2 ? NavColor : UIColor.whiteColor;
            }
        }
    }
}

/**
 计算高度

 @param height 控件高度
 @return 返回适配高度
 */
- (CGFloat)constraintWithHeight:(CGFloat)height {
    CGFloat proportion = 1.0;
    if (Is_IPHONE5) {
        //如果是 iPhone5比例设置为0.85
        proportion = 0.85;
    }else if (Is_IPHONE6Plus || Is_IPHONEX || Is_IPHONEXs || Is_IPHONEXs_Max || Is_IPHONEXr) {
        //如果是 6P,X,XS 或者 XS_MAX设置为 1.12
        proportion = 1.12;
    }
    return proportion * height;
}


@end
