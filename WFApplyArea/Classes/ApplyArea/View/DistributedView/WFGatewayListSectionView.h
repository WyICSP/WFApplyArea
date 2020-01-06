//
//  WFGatewayListSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFGatewayListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFGatewayListSectionView : UIView
/// 充电桩
@property (weak, nonatomic) IBOutlet UILabel *title;
/// 展开关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *showCountBtn;
/// 点击区
@property (weak, nonatomic) IBOutlet UIButton *chooseItemBtn;
/// 选中显示按钮
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
///  左边的间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftCons;
/// 点击或者打开
@property (copy, nonatomic) void (^selectOrOpenPileBlock)(NSInteger tag);
/// 赋值
@property (strong, nonatomic) WFGatewayListModel *model;
@end

NS_ASSUME_NONNULL_END
