//
//  WFManyTimesUnifiedTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFDefaultUnifiedListModel;
@class WFDefaultPowerListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFManyTimesUnifiedTableViewCell : UITableViewCell
/**钱背景*/
@property (weak, nonatomic) IBOutlet UIView *moneyView;
/**次数背景*/
@property (weak, nonatomic) IBOutlet UIView *countView;
/**查看表的按钮*/
@property (weak, nonatomic) IBOutlet UIButton *formBtn;
/**title*/
@property (weak, nonatomic) IBOutlet UILabel *title;
/**选中按钮*/
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/**钱的输入框*/
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
/**次数输入框*/
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/**跳转查看功率表*/
@property (nonatomic, copy) void (^clickLookFormBlock)(void);
/**统一收费赋值*/
@property (nonatomic, strong) WFDefaultUnifiedListModel *unModel;
/**功率收费赋值*/
@property (nonatomic, strong) WFDefaultPowerListModel *powModel;
/**0表示统一收费 1 表示功率收费 标志*/
@property (nonatomic, assign) NSInteger section;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;

/**
 绑定数据

 @param unModel 数据源
 @param section 区域
 */
- (void)bindToCellWithUnifiedModel:(WFDefaultUnifiedListModel *)unModel
                           section:(NSInteger)section;

/**
 绑定数据
 
 @param powModel 数据源
 @param section 区域
 */
- (void)bindToCellWithPowerModel:(WFDefaultPowerListModel *)powModel
                           section:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END
