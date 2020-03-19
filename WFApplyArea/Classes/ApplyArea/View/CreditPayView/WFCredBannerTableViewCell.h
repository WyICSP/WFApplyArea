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
/// img
@property (weak, nonatomic) IBOutlet UIImageView *img;
/// 跑马灯 view
@property (weak, nonatomic) IBOutlet UIView *lblContentsView;
/// 赋值
@property (nonatomic, strong) WFCreditPayModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
