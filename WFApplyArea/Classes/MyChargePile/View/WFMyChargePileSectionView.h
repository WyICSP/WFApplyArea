//
//  WFMyChargePileSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFMyChargePileModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFMyChargePileSectionView : UIView
/**左边*/
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
/**中间*/
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
/**右边*/
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
/**按钮数组*/
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btns;
/**点击事件*/
@property (nonatomic, copy) void (^clickBtnBlock)(NSInteger index);
/**title*/
@property (nonatomic, strong) NSArray *titles;
/**赋值*/
@property (nonatomic, strong) WFMyChargePileModel *model;
@end

NS_ASSUME_NONNULL_END
