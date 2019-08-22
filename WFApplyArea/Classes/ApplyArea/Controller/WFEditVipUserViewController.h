//
//  WFEditVipUserViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFGroupVipUserModel;

typedef NS_ENUM(NSInteger, WFEditAddUserType) {
    WFEditAddUserApplyType = 0,//申请片区的时候
    WFEditAddUserUpdateType //修改片区
};

NS_ASSUME_NONNULL_BEGIN

@interface WFEditVipUserViewController : YFBaseViewController
/**类型*/
@property (nonatomic, assign) WFEditAddUserType type;
/**申请片区 id*/
@property (nonatomic, copy) NSString *applyGroupId;
/**充电桩片区id*/
@property (nonatomic, copy) NSString *chargingModelId;
/**编辑的时候数据*/
@property (nonatomic, strong) WFGroupVipUserModel *itemModel;
@property (nonatomic, copy) WFEditVipUserViewController *(^eType)(WFEditAddUserType type);
@property (nonatomic, copy) WFEditVipUserViewController *(^aGroupId)(NSString *applyGroupId);
@property (nonatomic, copy) WFEditVipUserViewController *(^cModelId)(NSString *chargingModelId);
@property (nonatomic, copy) WFEditVipUserViewController *(^imodel)(WFGroupVipUserModel *itemModel);
@end

NS_ASSUME_NONNULL_END
