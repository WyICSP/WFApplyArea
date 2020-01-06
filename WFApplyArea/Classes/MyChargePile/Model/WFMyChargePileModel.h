//
//  WFMyChargePileModel.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMyChargePileModel : NSObject
/**使用率*/
@property (nonatomic, assign) CGFloat usage;
/**充电桩台数*/
@property (nonatomic, assign) NSInteger count;
/**未安装台数*/
@property (nonatomic, assign) NSInteger notInstalledCount;
/**异常台数*/
@property (nonatomic, assign) NSInteger abnormalCount;
/**是否选中我的充电桩*/
@property (nonatomic, assign) BOOL isSelectPile;
/**是否选中异常充电桩*/
@property (nonatomic, assign) BOOL isSelectAbnormalPile;
/**是否选中未安装*/
@property (nonatomic, assign) BOOL isNoInstallPile;
/**异常充电桩*/
@property (nonatomic, strong) NSArray *abnormalCdzList;
/**我的充电桩*/
@property (nonatomic, strong) NSArray *myCdzListList;
/**未安装充电桩*/
@property (nonatomic, strong) NSArray *notInstalledCdzList;
@end

@interface WFAbnormalCdzListModel : NSObject
/**片区名*/
@property (nonatomic, copy) NSString *name;
/**充电桩台数*/
@property (nonatomic, assign) NSInteger cdzNumber;
/**片区 Id*/
@property (nonatomic, copy) NSString *groupId;
@end

@interface WFMyCdzListListModel : NSObject
/**老片区Id*/
@property (nonatomic, copy) NSString *applyGroupId;
/**新片区Id*/
@property (nonatomic, copy) NSString *groupId;
/**片区名*/
@property (nonatomic, copy) NSString *name;
/**充电桩台数*/
@property (nonatomic, assign) NSInteger cdzNumber;
/**片区每日使用率*/
@property (nonatomic, assign) CGFloat utilizationRate;
/**是否是新片区*/
@property (nonatomic, assign) BOOL isNew;
@end

@interface WFNotInstalledCdzListModel : NSObject
/**桩号*/
@property (nonatomic, copy) NSString *shellId;
/**发货时间*/
@property (nonatomic, copy) NSString *createDate;
@end

@interface WFAbnormalPileListModel : NSObject
/**桩号*/
@property (nonatomic, copy) NSString *shellId;
/**时间*/
@property (nonatomic, copy) NSString *lastUseTime;
@property (nonatomic, copy) NSString *daysNoUse;
/**原因*/
@property (nonatomic, copy) NSString *abType;
@end

@interface WFSignleIntensityListModel : NSObject
/**桩号*/
@property (nonatomic, copy) NSString *shellId;
/// 桩号 ID
@property (nonatomic, copy) NSString *Id;
/**信号强度*/
@property (nonatomic, assign) NSInteger qos;
/**1在线 2离线*/
@property (nonatomic, assign) NSInteger status;
/// 子设备
@property (nonatomic, strong) NSArray *socketParamVOS;
/// 开始编辑
@property (nonatomic, assign) BOOL isEdit;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;
/// 是否打开
@property (nonatomic, assign) BOOL isOpen;
@end

@interface WFPileSocketParamVOSModel : NSObject
/// 编号
@property (nonatomic, assign) NSInteger socketNo;
/// 1 未充电 2 标识在充电
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
