//
//  WFDiviIntoSetEditTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMyAreaDividIntoSetModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFDiviIntoSetEditTableViewCell : UITableViewCell
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**姓名*/
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
/**手机*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/**百分比*/
@property (weak, nonatomic) IBOutlet UITextField *percentTF;
/**删除*/
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/**删除某一条数据*/
@property (nonatomic, copy) void (^deleteItemBlock)(void);
/**占比*/
@property (nonatomic, copy) void (^checkPresentBlock)(NSInteger present);
/**赋值*/
@property (nonatomic, strong) WFMyAreaDividIntoSetModel *model;
/**最大值*/
@property (nonatomic, assign) WFMyAreaDividIntoSetModel *maxModel;
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                        dataCount:(NSInteger)dataCount;
/**
 绑定数据

 @param model 数据
 @param maxModel 合伙人的分成比例
 */
- (void)bindToCellWithModel:(WFMyAreaDividIntoSetModel *)model
                 maxPresent:(WFMyAreaDividIntoSetModel *)maxModel;

@end

NS_ASSUME_NONNULL_END
