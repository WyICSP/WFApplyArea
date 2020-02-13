//
//  WFCreditPayTableViewCell.h
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFCreditPaymentVOListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFCreditPayTableViewCell : UITableViewCell
/// contentsView
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 分割xian线
@property (weak, nonatomic) IBOutlet UILabel *line;
/// icon
@property (weak, nonatomic) IBOutlet UIImageView *itemIcon;
/// 选中与不选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/// title
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 赋值
@property (nonatomic, strong) WFCreditPaymentVOListModel *model;
/// 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
                        indexPath:(NSIndexPath *)indexPath
                            dataCount:(NSInteger)dataCount;
@end

NS_ASSUME_NONNULL_END
