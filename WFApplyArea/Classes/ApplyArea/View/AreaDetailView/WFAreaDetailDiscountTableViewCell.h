//
//  WFAreaDetailDiscountTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailVipChargeModel;
@class WFAreaDetailSingleChargeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailDiscountTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet UILabel *timeByMoney;
/**长按删除*/
@property (nonatomic, copy) void (^longPressDeleteBlock)(NSInteger index);
/**赋值*/
@property (nonatomic, strong) WFAreaDetailVipChargeModel *model;
/**单次收费*/
@property (nonatomic, strong) WFAreaDetailSingleChargeModel *singleModel;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
