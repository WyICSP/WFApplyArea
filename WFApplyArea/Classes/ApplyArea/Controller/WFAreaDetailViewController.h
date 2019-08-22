//
//  WFAreaDetailViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WFAreaDetailShowType) {
    WFAreaDetailSingleType = 0,//单次收费
    WFAreaDetailManyTimesType,//多次收费
    WFAreaDetailDiscountType //优惠收费
};

typedef NS_ENUM(NSInteger, WFAreaDetailJumpType) {
    WFAreaDetailJumpAreaType = 0,//片区
    WFAreaDetailJumpPileType//我的充电桩
};

@interface WFAreaDetailViewController : YFBaseViewController
/**显示什么收费*/
@property (nonatomic, assign) WFAreaDetailShowType showType;
/**跳转Type*/
@property (nonatomic, assign) WFAreaDetailJumpType jumpType;
/**片区Id*/
@property (nonatomic, copy) NSString *groupId;
@end

NS_ASSUME_NONNULL_END
