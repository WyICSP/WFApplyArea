//
//  WFGatewayBottomView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFGatewayBottomView : UIView
/// 解绑按钮
@property (weak, nonatomic) IBOutlet UIButton *untyingBtn;
/// 替换按钮
@property (weak, nonatomic) IBOutlet UIButton *replaceBtn;
/// 按钮点击事件
@property (copy, nonatomic) void (^clickBotomBtnBlock)(NSInteger tag);
@end

NS_ASSUME_NONNULL_END
