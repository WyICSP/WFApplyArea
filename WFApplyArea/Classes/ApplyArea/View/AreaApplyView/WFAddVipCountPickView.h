//
//  WFAddVipCountPickView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFAddVipCountPickView : UIView
@property (nonatomic, copy) void(^chooseCountMsgBlock)(NSString *count);
@end

NS_ASSUME_NONNULL_END
