//
//  WFGatewayListTableViewCell.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/21.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFGatewayLoarListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFGatewayListTableViewCell : UITableViewCell
/// 选中按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
/// 设备离左边的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCons;
/// collectionView 左间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionLeftCons;
/// 子设备 view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemVieqHeight;
/// title
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 赋值
@property (nonatomic, strong) WFGatewayLoarListModel *model;
/// 选中和打开
@property (nonatomic, copy) void (^selectItemBlock)(NSInteger tag,BOOL isSelect);
/**初始化*/
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
