//
//  WFAreaDetailAddressTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailAddressTableViewCell.h"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@implementation WFAreaDetailAddressTableViewCell

static NSString *const cellId = @"WFAreaDetailAddressTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailAddressTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
    self.topBgView.backgroundColor = NavColor;
    self.detailAddress.adjustsFontSizeToFitWidth = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindToCell:(WFAreaDetailModel *)model {
    
    self.editBtn.hidden = !model.isUpdate;
    if (model.status) {
        //0：申请中 1：申请通过 2：申请驳回
        if (model.auditStatus == 0) {
            self.status.text = @"使用中";
        }else if (model.auditStatus == 1) {
            self.status.text = @"审核通过";
        }else {
            self.status.text = @"审核驳回";
        }
    }else {
        self.status.text = @"已停用";
    }
    
    
    self.address.text = model.areaName;
    self.detailAddress.text = model.address;
    self.areaName.text = model.name;
}

- (IBAction)clickEditBtn:(id)sender {
    !self.clickEditBtnBlock ? : self.clickEditBtnBlock();
}
@end
