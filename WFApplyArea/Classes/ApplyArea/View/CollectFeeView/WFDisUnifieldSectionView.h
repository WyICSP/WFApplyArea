//
//  WFDisUnifieldSectionView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFDisUnifieldSectionView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**添加按钮*/
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
/**添加手机号*/
@property (nonatomic, copy) void (^addUserPhoneBlock)(void);
@end

NS_ASSUME_NONNULL_END
