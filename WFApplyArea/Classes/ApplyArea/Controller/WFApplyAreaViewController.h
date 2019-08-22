//
//  WFApplyAreaViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFApplyAreaViewController : YFBaseViewController
/**刷新数据*/
@property (nonatomic, copy) void(^reloadDataBlock)(void);
@end

NS_ASSUME_NONNULL_END
