//
//  WFDatePickView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFDatePickView : UIView
@property (nonatomic, copy) void(^chooseDateMsgString)(NSString *date);
@end

NS_ASSUME_NONNULL_END
