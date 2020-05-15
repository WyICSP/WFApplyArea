//
//  WFProductListTableViewCell.m
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFProductListTableViewCell.h"
#import "WFProductListModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AttributedLbl.h"
#import "WKHelp.h"

@implementation WFProductListTableViewCell

static NSString *const cellId = @"WFProductListTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFProductListTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.shareBtn.layer.cornerRadius = 27/2.0f;
    self.imgView.layer.cornerRadius = 5.0f;
    SKViewsBorder(self.guideCoupon, 3, 0.5, NavColor);
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)clickBtn:(UIButton *)sender {
    !self.clickBtnBlock ? : self.clickBtnBlock(sender.tag);
}

- (void)setModel:(WFProductListModel *)model {
    self.shareBtn.hidden = NO;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.pictUrl] placeholderImage:[UIImage imageNamed:@"pfang"]];
    self.title.text = model.title;
    //店铺名
    self.buyCount.text = model.storeName;
    //销售价
    self.salePrice.text = [NSString stringWithFormat:@"¥%@",@(model.couponAfterPrice.integerValue/100.0f)];
    NSString *salePrice = [NSString stringWithFormat:@"¥ %@",@(model.couponAfterPrice.integerValue/100.0f)];
    [AttributedLbl setRichTextOnlyFont:self.salePrice titleString:salePrice textFont:[UIFont boldSystemFontOfSize:12] fontRang:NSMakeRange(0, 1)];
    //原价
    self.origPrice.text = [NSString stringWithFormat:@"¥%@",@(model.oriPrice.integerValue/100.0f)];
    //导购券
    self.guideCoupon.text = [NSString stringWithFormat:@"  导购券%@元  ",@(model.ticketAmount.integerValue/100.0f)];
    self.guideCoupon.hidden = model.ticketId.intValue == 0 ? YES : NO;
    
    //分享赚
    NSString *sharePrice = [NSString stringWithFormat:@"  赚%@红包",@(model.shareTicketAmount.integerValue/100.0f)];
    [self.shareBtn setTitle:sharePrice forState:0];
}


@end
