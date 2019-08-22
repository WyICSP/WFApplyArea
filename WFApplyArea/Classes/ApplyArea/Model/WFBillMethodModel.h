//
//  WFBillMethodModel.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/14.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFBillMethodModel : NSObject
/**充电时长*/
@property (nonatomic, strong) NSArray *billingTimeMethods;
/**是否打开第一个区域*/
@property (nonatomic, assign) BOOL isOpenFirstSection;
/**是否选中第一个区域的头视图*/
@property (nonatomic, assign) BOOL isSelectFirstSection;
/**第一个区域选中的数量*/
@property (nonatomic, assign) NSInteger firstSelectNum;

/**充电金额*/
@property (nonatomic, strong) NSArray *billingPriceMethods;
/**是否打开第二个区域*/
@property (nonatomic, assign) BOOL isOpenSecondSection;
/**是否选中第二个区域的头视图*/
@property (nonatomic, assign) BOOL isSelectSecondSection;
/**第二个区域选中的数量*/
@property (nonatomic, assign) NSInteger secondSelectNum;
/**是否有编辑*/
@property (nonatomic, assign) BOOL isChange;
@end

@interface WFBillingTimeMethodModel : NSObject
/**计费id*/
@property (nonatomic, copy) NSString *billingPlanId;
/**计费类型，1:小时计费 2:金额计费*/
@property (nonatomic, assign) NSInteger billingPlay;
/**计费名称*/
@property (nonatomic, copy) NSString *billingName;
/**计费值*/
@property (nonatomic, strong) NSNumber *billingValue;
/**单位*/
@property (nonatomic, copy) NSString *billingUnit;
/**电量*/
@property (nonatomic, copy) NSString *elec;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end


@interface WFBillingPriceMethodModel : NSObject
/**计费id*/
@property (nonatomic, copy) NSString *billingPlanId;
/**计费类型，1:小时计费 2:金额计费*/
@property (nonatomic, assign) NSInteger billingPlay;
/**计费名称*/
@property (nonatomic, copy) NSString *billingName;
/**计费值*/
@property (nonatomic, strong) NSNumber *billingValue;
/**单位*/
@property (nonatomic, copy) NSString *billingUnit;
/**电量*/
@property (nonatomic, assign) CGFloat elec;
/**是否选中*/
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
