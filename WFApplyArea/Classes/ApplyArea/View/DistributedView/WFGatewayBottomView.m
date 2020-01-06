//
//  WFGatewayBottomView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFGatewayBottomView.h"

@implementation WFGatewayBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickGateBtn:(UIButton *)sender {
    !self.clickBotomBtnBlock ? : self.clickBotomBtnBlock(sender.tag);
}

@end
