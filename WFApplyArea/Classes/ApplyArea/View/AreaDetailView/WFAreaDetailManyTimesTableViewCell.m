//
//  WFAreaDetailManyTimesTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailManyTimesTableViewCell.h"
#import "WFDiscountItemTableViewCell.h"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@interface WFAreaDetailManyTimesTableViewCell()

@end

@implementation WFAreaDetailManyTimesTableViewCell

static NSString *const cellId = @"WFAreaDetailManyTimesTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailManyTimesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailManyTimesTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];//初始化一个长按手势
    [longPress setMinimumPressDuration:0.4];//设置按多久之后触发事件
    [self.contentsView addGestureRecognizer:longPress];//把长按手势添加给按钮
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        !self.longPressDeleteBlock ? : self.longPressDeleteBlock(100);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFAreaDetailMultipleModel *)model {
    self.leftLbl.text = model.optionName;
    self.timeByMoney.text = [NSString stringWithFormat:@"%@ 元    %ld 小时",@(model.proposalPrice.floatValue/100),(long)model.proposalTimes];
}


@end
