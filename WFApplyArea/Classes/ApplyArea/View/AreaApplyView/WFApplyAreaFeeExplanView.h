//
//  WFApplyAreaFeeExplanView.h
//  AFNetworking
//
//  Created by 王宇 on 2019/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaFeeExplanView : UIView
/**知道*/
@property (weak, nonatomic) IBOutlet UIButton *knowBtn;
/**按钮点击时间*/
@property (copy, nonatomic) void(^clickKnowBtnBlock)(void);
@end

NS_ASSUME_NONNULL_END
