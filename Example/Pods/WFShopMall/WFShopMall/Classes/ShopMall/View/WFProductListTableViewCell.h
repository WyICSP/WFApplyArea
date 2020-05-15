//
//  WFProductListTableViewCell.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFProductListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFProductListTableViewCell : UITableViewCell
/**图片*/
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/**商品名*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**售价*/
@property (weak, nonatomic) IBOutlet UILabel *salePrice;
/**原价*/
@property (weak, nonatomic) IBOutlet UILabel *origPrice;
/**导购券*/
@property (weak, nonatomic) IBOutlet UILabel *guideCoupon;
/**店铺名*/
@property (weak, nonatomic) IBOutlet UILabel *buyCount;
/**分享按钮*/
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/**点击事件*/
@property (copy, nonatomic) void (^clickBtnBlock)(NSInteger tag);
/// 赋值
@property (nonatomic, strong) WFProductListModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
