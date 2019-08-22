//
//  WFBilleMethodMoneyTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFBillingPriceMethodModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFBilleMethodMoneyTableViewCell : UITableViewCell
/**充电时间*/
@property (nonatomic, strong) NSArray <WFBillingPriceMethodModel *> *models;
/**cell高度*/
@property (nonatomic, assign) CGFloat cellHeight;
/**是否有数据*/
//@property (nonatomic, copy) void (^isHaceMoneyItemBlock)(BOOL isHave);
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 绑定数据
 
 @param models 数据源
 @param cellHeight 高度
 */
- (void)bindToCell:(NSArray <WFBillingPriceMethodModel *> *)models
        cellHeight:(CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
