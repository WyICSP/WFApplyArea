//
//  WFPowerIntervalModel.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/15.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFPowerIntervalModel : NSObject
/**次数*/
@property (nonatomic, assign) NSInteger time;
/**功率区间*/
@property (nonatomic, copy) NSString *powerInterval;
/**id*/
@property (nonatomic, copy) NSString *powerIntervalId;
@end

@interface WFProfitTableModel : NSObject
/**id*/
@property (nonatomic, copy) NSString *powerIntervalId;
/**功率区间*/
@property (nonatomic, copy) NSString *powerInterval;
/**单价*/
@property (nonatomic, strong) NSNumber *unitPrice;
/**售价*/
@property (nonatomic, strong) NSNumber *salesPrice;
@end

@interface WFApplyAreaAddressModel : NSObject
/**省市区*/
@property (nonatomic, copy) NSString *address;
/**区域 Id*/
@property (nonatomic, copy) NSString *addressId;
/**详细地址*/
@property (nonatomic, copy) NSString *detailAddress;
/**片区名*/
@property (nonatomic, copy) NSString *areaName;
/// 经度
@property (nonatomic, copy) NSString *changingGroupLon;
/// 纬度
@property (nonatomic, copy) NSString *chargingGroupLat;
@end

NS_ASSUME_NONNULL_END
