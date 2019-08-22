//
//  WFManyTimesFooterView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/8.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFManyTimesFooterView.h"
#import "WKHelp.h"

@implementation WFManyTimesFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lookBtn.layer.cornerRadius = self.lookBtn.frame.size.height/2;
    self.lookBtn.layer.borderWidth = 0.5;
    self.lookBtn.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
}

- (IBAction)clickBtn:(id)sender {
    !self.clickLookBtnBlock ? : self.clickLookBtnBlock();
}

@end
