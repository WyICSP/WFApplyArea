//
//  WFEditAreaAddressViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/31.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFAreaDetailModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WFEditAddressJumpType) {
    WFEditAddressAreaDetailType = 0, //片区详情过来
    WFEditAddressAreauUpgradeType //升级片区过来
};

@interface WFEditAreaAddressViewController : YFBaseViewController
/**带过来数据*/
@property (nonatomic, strong) WFAreaDetailModel *models;
/**来源 type*/
@property (nonatomic, assign) WFEditAddressJumpType type;

@property (nonatomic, copy) WFEditAreaAddressViewController *(^dataModels)(WFAreaDetailModel *models);
@property (nonatomic, copy) WFEditAreaAddressViewController *(^sourceType)(WFEditAddressJumpType type);
@end

NS_ASSUME_NONNULL_END
