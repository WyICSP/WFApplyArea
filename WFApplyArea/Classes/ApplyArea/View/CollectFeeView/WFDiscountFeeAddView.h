//
//  WFDiscountFeeAddView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFDiscountFeeAddView : UIView
/**背景*/
@property (weak, nonatomic) IBOutlet UIView *contentsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centercX;

/**电话背景*/
@property (weak, nonatomic) IBOutlet UIView *phoneView;
/**时间背景*/
@property (weak, nonatomic) IBOutlet UIView *dateView;
/**此时背景*/
@property (weak, nonatomic) IBOutlet UIView *countView;
/**电话*/
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
/**时间*/
@property (weak, nonatomic) IBOutlet UITextField *dateTF;
/**次数*/
@property (weak, nonatomic) IBOutlet UITextField *countTF;
/**取消*/
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
/**确定*/
@property (weak, nonatomic) IBOutlet UIButton *comfireBtn;
/**确定或者取消 10 取消 20 确定*/
@property (nonatomic, copy) void (^addOrCancelBlock)(NSInteger tag);

@end

NS_ASSUME_NONNULL_END
