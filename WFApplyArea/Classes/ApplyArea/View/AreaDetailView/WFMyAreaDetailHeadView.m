//
//  WFMyAreaDetailHeadView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaDetailHeadView.h"

@implementation WFMyAreaDetailHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.feeBtn.layer.cornerRadius = self.pileBtn.layer.cornerRadius = 45.0f/2;
}

/**
 100 收费按钮 200 充电桩按钮
 */
- (IBAction)clickBtn:(UIButton *)sender {
    if (sender.tag == 100) {
        self.feeBtn.selected = self.rightFoot.hidden = YES;
        self.pileBtn.selected = self.leftFoot.hidden = NO;
        self.feeBtn.backgroundColor = UIColor.whiteColor;
        self.pileBtn.backgroundColor = UIColor.clearColor;
    }else {
        self.feeBtn.selected = self.rightFoot.hidden = NO;
        self.pileBtn.selected = self.leftFoot.hidden = YES;
        self.feeBtn.backgroundColor = UIColor.clearColor;
        self.pileBtn.backgroundColor = UIColor.whiteColor;
    }
    
    !self.clickBtnBlock ? : self.clickBtnBlock(sender.tag);
    
}

@end
