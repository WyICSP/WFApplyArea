//
//  WFUpgradeAreaModel.h
//  AFNetworking
//
//  Created by 王宇 on 2019/9/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFUpgradeAreaModel : NSObject
/**地址*/
@property (nonatomic, copy) NSString *address;
/**城市名*/
@property (nonatomic, copy) NSString *cityName;
/**片区 Id*/
@property (nonatomic, copy) NSString *groupId;
/**片区名*/
@property (nonatomic, copy) NSString *name;
/**城市Id*/
@property (nonatomic, copy) NSString *regionId;

@end

@interface WFUpgradeAreaDiscountModel : NSObject
/**0:不存在Vip套餐 1:存在vip套餐*/
@property (nonatomic, assign) BOOL isExist;
/**老的Vip会员*/
@property (nonatomic, strong) NSArray *vipMemberList;
@end

NS_ASSUME_NONNULL_END
