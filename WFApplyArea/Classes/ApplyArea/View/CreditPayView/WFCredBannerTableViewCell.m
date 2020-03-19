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
#import "WFHorseRaceLamp.h"
#import "WKHelp.h"

@interface WFCredBannerTableViewCell()

@property (nonatomic, weak) WFHorseRaceLamp *marqueeControl;

@end

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Getter Setter
- (void)setModel:(WFCreditPayModel *)model {
    NSString *path = [model.pageUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [self.bannerImgView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"chang"]];
    self.marqueeControl.marqueeLabel.text = model.advertisingLanguage;
}



- (WFHorseRaceLamp *)marqueeControl {
    if (!_marqueeControl) {
        WFHorseRaceLamp *control = [[WFHorseRaceLamp alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.img.frame) + 5.0f, 0, ScreenWidth-60.0f, 36.f)];
        control.backgroundColor = [UIColor whiteColor];
        control.marqueeLabel.textColor = NavColor;
        control.marqueeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.lblContentsView addSubview:control];
        
        _marqueeControl = control;
    }
    
    return _marqueeControl;
}

@end
