//
//  WFManyTimesFooterView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/8.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFManyTimesFooterView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/**查看按钮*/
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
/**设置圆角 View*/
@property (weak, nonatomic) IBOutlet UIView *yuanViews;

/**点击事件*/
@property (nonatomic, copy) void (^clickLookBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
