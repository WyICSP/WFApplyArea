//
//  WFCreditPayViewController.h
//  WFKit
//
//  Created by 王宇 on 2020/2/11.
//  Copyright © 2020 王宇. All rights reserved.
//

#import "YFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WFCreditPayViewController : YFBaseViewController
/// 0 来源于申请充电桩 1 是来源于首页
@property (nonatomic, assign) NSInteger sourceType;
@end

NS_ASSUME_NONNULL_END
