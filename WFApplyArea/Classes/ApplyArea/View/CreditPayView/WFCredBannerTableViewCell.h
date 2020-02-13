//
//  WFCredBannerTableViewCell.h
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFCreditPayModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFCredBannerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgView;
@property (weak, nonatomic) IBOutlet UILabel *explanLbl;

/// 赋值
@property (nonatomic, strong) WFCreditPayModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
