//
//  WFAreaDetailCollectFeeSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaDetailCollectFeeSectionView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**查看表*/
@property (weak, nonatomic) IBOutlet UIButton *formBtn;
/**按钮集合*/
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
/**左边按钮*/
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
/**中间按钮*/
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
/**右边按钮*/
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
/**赋值*/
@property (nonatomic, strong) WFAreaDetailModel *model;
/**点击手机*/
@property (nonatomic, copy) void (^clickBtnBlock)(NSString *btnTitle);

@end

NS_ASSUME_NONNULL_END
