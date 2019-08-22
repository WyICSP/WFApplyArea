//
//  WFEditAreaDetailViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFEditAreaDetailViewController : YFBaseViewController
/**片区详情数据*/
@property (nonatomic, strong) WFAreaDetailModel *models;

@end

NS_ASSUME_NONNULL_END
