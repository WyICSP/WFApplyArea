//
//  WFAreaDetailDiscountTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailDiscountTableViewCell.h"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@implementation WFAreaDetailDiscountTableViewCell

static NSString *const cellId = @"WFAreaDetailDiscountTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailDiscountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailDiscountTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];//初始化一个长按手势
    [longPress setMinimumPressDuration:0.4];//设置按多久之后触发事件
    [self.contentsView addGestureRecognizer:longPress];//把长按手势添加给按钮
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        !self.longPressDeleteBlock ? : self.longPressDeleteBlock(200);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFAreaDetailVipChargeModel *)model {
//    self.price.text = [NSString stringWithFormat:@"%@",@(model.unifiedPrice.floatValue/100)];
//    self.time.text = [NSString stringWithFormat:@"%ld",(long)model.unifiedTime];
    self.timeByMoney.text = [NSString stringWithFormat:@"%@ 元    %ld 小时",@(model.unifiedPrice.floatValue/100),(long)model.unifiedTime];
}

- (void)setSingleModel:(WFAreaDetailSingleChargeModel *)singleModel {
    self.timeByMoney.text = [NSString stringWithFormat:@"%@ 元    %ld 小时",@(singleModel.unifiedPrice.floatValue/100),(long)singleModel.unifiedTime];
}

@end
