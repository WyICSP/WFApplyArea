//
//  WFCredBannerTableViewCell.m
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import "WFCredBannerTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WFCreditPayModel.h"

@implementation WFCredBannerTableViewCell

static NSString *const cellId = @"WFCredBannerTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFCredBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFCredBannerTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.explanLbl.adjustsFontSizeToFitWidth = YES;
    self.explanLbl.minimumScaleFactor = 0.5;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFCreditPayModel *)model {
    NSString *path = [model.pageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"chang"]];
    self.explanLbl.text = model.advertisingLanguage;
}

@end
