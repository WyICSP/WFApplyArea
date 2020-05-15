//
//  WFShopNavbarView.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFShopNavbarView.h"
#import "UIView+Frame.h"
@implementation WFShopNavbarView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.searchBtn.layer.cornerRadius = 14.5f;
    
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.clickBtnBlock ? : self.clickBtnBlock(sender.tag);
}

/**是否显示我的收益*/
- (void)hideIncomeView:(BOOL)show {
    
    
    self.contentView.width = show ? 50.0f : 100.0f;
    self.incomeBut.hidden = !show;
    self.incomeTitle.hidden = !show;
    self.incomeImageView.hidden = !show;
    self.incomeGap.constant = !show ? -40.0f : 14.0f;
}

@end
