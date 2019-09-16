//
//  WFApplyAreaFeeExplanView.m
//  AFNetworking
//
//  Created by 王宇 on 2019/9/16.
//

#import "WFApplyAreaFeeExplanView.h"

@implementation WFApplyAreaFeeExplanView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.knowBtn.layer.cornerRadius = 20.0f;
}
- (IBAction)clickKnowBtn:(id)sender {
    !self.clickKnowBtnBlock ? : self.clickKnowBtnBlock();
}

@end
