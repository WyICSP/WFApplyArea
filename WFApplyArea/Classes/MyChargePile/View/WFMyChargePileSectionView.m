//
//  WFMyChargePileSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyChargePileSectionView.h"
#import "WFMyChargePileModel.h"
#import "WKHelp.h"

@implementation WFMyChargePileSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIButton *btn in self.btns) {
        btn.layer.cornerRadius = 33/2;
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.clickBtnBlock ? : self.clickBtnBlock(sender.tag);
}

- (void)setModel:(WFMyChargePileModel *)model {
    
    for (UIButton *btn in self.btns) {
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:0];
        btn.backgroundColor = UIColor.clearColor;
    }
    
    if (model.isSelectPile) {
        //选中我的充电桩
        [self.leftBtn setTitleColor:UIColor.whiteColor forState:0];
        self.leftBtn.backgroundColor = NavColor;
    }else if (model.isSelectAbnormalPile) {
        //选中异常充电桩
        [self.centerBtn setTitleColor:UIColor.whiteColor forState:0];
        self.centerBtn.backgroundColor = NavColor;
    }else if (model.isNoInstallPile) {
        //选中未安装充电桩
        [self.rightBtn setTitleColor:UIColor.whiteColor forState:0];
        self.rightBtn.backgroundColor = NavColor;
    }
}

- (void)setTitles:(NSArray *)titles {
    for (int i = 0; i < self.btns.count; i ++) {
        UIButton *btn = self.btns[i];
        [btn setTitle:titles[i] forState:0];
    }
}


@end
