//
//  WFAreaDetailAddressTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailAddressTableViewCell : UITableViewCell
/**状态*/
@property (weak, nonatomic) IBOutlet UILabel *status;
/**地址信息*/
@property (weak, nonatomic) IBOutlet UILabel *address;
/**地址信息*/
@property (weak, nonatomic) IBOutlet UILabel *detailAddress;
/**片区名称*/
@property (weak, nonatomic) IBOutlet UILabel *areaName;
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**编辑按钮*/
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

/**点击编辑按钮*/
@property (nonatomic, copy) void (^clickEditBtnBlock)(void);

/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/**
 绑定数据

 @param model 数据源
 @param addressHeight 地址高度
 */
- (void)bindToCell:(WFAreaDetailModel *)model;
@end

NS_ASSUME_NONNULL_END
