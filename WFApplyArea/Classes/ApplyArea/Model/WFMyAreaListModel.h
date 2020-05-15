//
//  WFMyAreaListModel.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/12.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaListModel : NSObject
/**老片区id*/
@property (nonatomic, copy) NSString *applyGroupId;
/**申请片区id*/
@property (nonatomic, copy) NSString *groupId;
/**创建时间*/
@property (nonatomic, copy) NSString *createTime;
/**片区地址*/
@property (nonatomic, copy) NSString *groupAddress;
/**片区名称*/
@property (nonatomic, copy) NSString *groupName;
/// 0:停用 1:启用
@property (nonatomic, assign) BOOL status;
/**是否新片区*/
@property (nonatomic, assign) BOOL isNew;
/// 是否首次使用
@property (nonatomic, assign) BOOL isInstall;
/**片区审核状态 0：申请中 1：申请通过 2：申请驳回*/
@property (nonatomic, assign) NSInteger auditStatus;
/**0:待处理 1：通过 2:驳回 3：编辑 4：编辑失败*/
@property (nonatomic, assign) NSInteger applyGroupStatus;
@end

@interface WFMyAreaQRcodeModel : NSObject
/**片区二维码*/
@property (nonatomic, copy) NSString *shareUrl;
/**时间戳*/
@property (nonatomic, copy) NSString *expirationMsec;
/**二维码*/
@property (nonatomic, copy) NSString *qrCodeId;
/**二维码*/
@property (nonatomic, copy) NSString *Id;
@end

@interface WFMyAreaDividIntoSetModel : NSObject
/**名字*/
@property (nonatomic, copy) NSString *name;
/**手机号*/
@property (nonatomic, copy) NSString *phone;
/**占比*/
@property (nonatomic, assign) NSInteger rate;
/**1是合伙人 0 公司 2 是其他*/
@property (nonatomic, assign) NSInteger chargePersonFlag;
/// 是否是新增的
@property (nonatomic, assign) BOOL isAdd;
/// 是否允许编辑
@property (nonatomic, assign) BOOL isAllowEditName;
@end


@interface WFApplyChargeMethod : NSObject
/**收费标准id*/
@property (nonatomic, copy) NSString *chargeModelId;
/**收费标准名称*/
@property (nonatomic, copy) NSString *chargingModelName;
/**1 = 单次收费2 = 多次收费3 = 优惠收费*/
@property (nonatomic, copy) NSString *chargingModePlay;
/**0: 不是必须 1: 必须*/
@property (nonatomic, assign) BOOL isNecessary;
@end

NS_ASSUME_NONNULL_END
