//
//  WFLookPowerFormViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>


typedef NS_ENUM(NSUInteger, WFLookFormType) {
    WFLookFormProfitType = 0,//利润表
    WFLookFormPowerType,//功率表
    WFLookFormVipType//会员
};

NS_ASSUME_NONNULL_BEGIN

@interface WFLookPowerFormViewController : YFBaseViewController
/**类型表*/
@property (nonatomic, assign) WFLookFormType formType;
/**销售价*/
@property (nonatomic, strong) NSNumber *salesPrice;
/**单价*/
@property (nonatomic, strong) NSNumber *unitPrice;
/**片区 id*/
@property (nonatomic, strong) NSString *groupId;
@property (nonatomic, copy) WFLookPowerFormViewController *(^formTypes)(WFLookFormType formType);
@property (nonatomic, copy) WFLookPowerFormViewController *(^salesPrices)(NSNumber *salesPrice);
@property (nonatomic, copy) WFLookPowerFormViewController *(^unitPrices)(NSNumber *unitPrice);
@property (nonatomic, copy) WFLookPowerFormViewController *(^groupIds)(NSString *groupId);
@end

NS_ASSUME_NONNULL_END
