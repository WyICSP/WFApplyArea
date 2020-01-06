//
//  WFGatewayListSectionView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFGatewayListSectionView.h"
#import "WFGatewayListModel.h"

@implementation WFGatewayListSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.selectOrOpenPileBlock ? : self.selectOrOpenPileBlock(sender.tag);
}

- (void)setModel:(WFGatewayListModel *)model {
    self.title.text = model.gateWayCode.length == 0 ? @"            " : model.gateWayCode;
    //是否选中
    self.selectBtn.selected = model.isSelect;
    //是否打开
    self.showCountBtn.selected = model.isOpen;

    [self.showCountBtn setTitle:[NSString stringWithFormat:@"%ld",(long)model.count] forState:0];
}

@end
