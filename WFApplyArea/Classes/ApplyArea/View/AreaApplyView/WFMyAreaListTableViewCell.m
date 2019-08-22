//
//  WFMyAreaListTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaListTableViewCell.h"
#import "WFMyAreaListModel.h"
#import "WKHelp.h"

@implementation WFMyAreaListTableViewCell

static NSString *const cellId = @"WFMyAreaListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFMyAreaListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMyAreaListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.qrBtn.layer.borderColor = UIColorFromRGB(0xE4E4E4).CGColor;
    self.qrBtn.layer.borderWidth = 0.7f;
    self.qrBtn.layer.cornerRadius = self.qrBtn.frame.size.height / 2;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFMyAreaListModel *)model {
    //片区名
    self.name.text = model.groupName;
    //地址
    self.address.text = model.groupAddress;
    //事件
    self.time.text = model.createTime;
    //状态 0：申请中 1：申请通过 2：申请驳回*/
    self.qrBtn.hidden = model.auditStatus == 2;
    if (model.auditStatus == 0) {
        self.state.text = @"审核中";
        self.state.textColor = NavColor;
    }else if (model.auditStatus == 1) {
        self.state.text = @"审核通过";
        self.state.textColor = UIColorFromRGB(0x333333);
    }else if (model.auditStatus == 2) {
        self.state.text = @"审核驳回";
        self.state.textColor = NavColor;
    }
}


- (IBAction)clickBtn:(id)sender {
    !self.showQRCodeBlock ? : self.showQRCodeBlock();
}


@end
