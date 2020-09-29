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
    
    SKViewsBorder(self.moveBtn, self.moveBtn.frame.size.height / 2, 0.7f, UIColorFromRGB(0xE4E4E4));
    
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
        
    if (model.isInstall) {
        // 如果是首次安装
        if (model.auditStatus != 2) {
            self.qrBtn.hidden = NO;
            [self.qrBtn setTitle:@"首次安装" forState:0];
            self.qrBtn.tag = 100;
        } else {
            self.qrBtn.hidden = YES;
        }
    } else {
        // 移入设备
        [self.qrBtn setTitle:@"移入设备" forState:0];
        self.qrBtn.tag = 110;
        self.qrBtn.hidden = NO;
    }
    
//    if (model.auditStatus == 2) {
//
//    }
//
//
//    if (model.auditStatus == 2) {
//        self.moveBtn.hidden = YES;
//        [self.qrBtn setTitle:@"移入设备" forState:0];
//        self.qrBtn.tag = 110;
//    }else {
//        self.moveBtn.hidden = NO;
//        [self.qrBtn setTitle:@"二维码" forState:0];
//        self.qrBtn.tag = 100;
//    }
    
    if (model.status) {
        if (model.isNew) {
            //新片区 状态 0：申请中 1：申请通过 2：申请驳回*/
            if (model.auditStatus == 0) {
                self.state.text = @"使用中";
                self.state.textColor = NavColor;
            }else if (model.auditStatus == 1) {
                self.state.text = @"审核通过";
                self.state.textColor = UIColorFromRGB(0x333333);
            }else if (model.auditStatus == 2) {
                self.state.text = @"审核驳回";
                self.state.textColor = NavColor;
            }
        }else {
            //老片区 0:待处理 1：通过 2:驳回 3：编辑 4：编辑失败
            if (model.applyGroupStatus == 0) {
                self.state.text = @"待处理";
                self.state.textColor = NavColor;
            }else if (model.applyGroupStatus == 1) {
                self.state.text = @"审核通过";
                self.state.textColor = UIColorFromRGB(0x333333);
            }else if (model.applyGroupStatus == 2) {
                self.state.text = @"审核驳回";
                self.state.textColor = NavColor;
            }else if (model.applyGroupStatus == 3) {
                self.state.text = @"等待审核";
                self.state.textColor = NavColor;
            }else if (model.applyGroupStatus == 4) {
                self.state.text = @"编辑失败";
                self.state.textColor = NavColor;
            }
        }
    }else {
        self.state.text = @"已停用";
        self.state.textColor = NavColor;
    }
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.showQRCodeBlock ? : self.showQRCodeBlock(sender.tag);
}


@end
