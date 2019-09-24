//
//  WFDisUnifieldFeeTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFDefaultDiscountModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFDisUnifieldFeeTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**钱View*/
@property (weak, nonatomic) IBOutlet UIView *moneyView;
/**时间*/
@property (weak, nonatomic) IBOutlet UIView *dateView;
/**输入钱*/
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
/**输入的时间*/
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
/**只读*/
@property (weak, nonatomic) IBOutlet UIView *isOnlyReadView;
/**只读价格*/
@property (weak, nonatomic) IBOutlet UILabel *onlyPriceLbl;
/**只读时间*/
@property (weak, nonatomic) IBOutlet UILabel *onlyTimeLbl;
/**老片区升级是否选中*/
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/**title 离左边的间距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftCons;
/**选中按钮的宽度*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
/**选中效果*/
@property (nonatomic, copy) void (^clickSelectItemBlock)(BOOL isSelect);
/**赋值操作*/
@property (nonatomic, strong) WFDefaultDiscountModel *model;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
