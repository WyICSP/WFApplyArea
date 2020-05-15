//
//  WFShopNavbarView.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/9/23.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopNavbarView : UIView
/**搜索按钮*/
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
/**点击事件 tag 10 搜索 20 攻略  30 收益*/
@property (copy, nonatomic) void (^clickBtnBlock)(NSInteger tag);
/**收益 but*/
@property (weak, nonatomic) IBOutlet UIButton *incomeBut;
/**图片*/
@property (weak, nonatomic) IBOutlet UIImageView *incomeImageView;
/**标题*/
@property (weak, nonatomic) IBOutlet UILabel *incomeTitle;
/**内容view*/
@property (weak, nonatomic) IBOutlet UIView *contentView;
/**间距*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *incomeGap;


/**是否显示我的收益*/
- (void)hideIncomeView:(BOOL)show;
@end

NS_ASSUME_NONNULL_END
