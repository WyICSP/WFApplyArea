//
//  WFShopMallHeadView.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopMallHeadView : UIView
/// 按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
///  红包按钮
@property (weak, nonatomic) IBOutlet UIButton *redBtn;
/// 筛选
@property (copy, nonatomic) void (^screenProductBlock)(NSInteger tag, BOOL isTop);
/// 按钮显示类型
@property (nonatomic, assign) BOOL topOrDowm;
/// 按钮 tag 按钮切换的时候保证记录上次的状态
@property (nonatomic, assign) NSInteger btnTag;
@end

NS_ASSUME_NONNULL_END
