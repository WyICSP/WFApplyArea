//
//  WFBilleMethodSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFBilleMethodSectionView : UIView
/**
 背景
 */
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**
 title
 */
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UILabel *title;

/**
 展开和闭合图片
 */
@property (weak, nonatomic) IBOutlet UIButton *showImgBtn;

/**
 点击按钮 10 选中按钮 20 打开 关闭
 */
@property (copy, nonatomic) void (^clickSectionBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
