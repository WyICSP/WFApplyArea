//
//  WFDividIntoSetViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFMyAreaDividIntoSetModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFDividIntoSetSourceType) {
    WFDividIntoSetApplyType = 0,//申请片区的时候
    WFDividIntoSetUpdateType,   //修改片区
    WFDividIntoSetUpgradeType   //升级片区
};

@interface WFDividIntoSetViewController : YFBaseViewController
/**数据*/
@property (nonatomic, strong) NSMutableArray <WFMyAreaDividIntoSetModel *> *models;
/**填写的数据*/
@property (nonatomic, copy) void (^dividIntoDataBlock)(NSArray <WFMyAreaDividIntoSetModel *> *models);
/**片区 Id*/
@property (nonatomic, copy) NSString *groupId;
/**chargingModelId*/
@property (nonatomic, copy) NSString *chargingModelId;
/**来源*/
@property (nonatomic, assign) WFDividIntoSetSourceType type;

@property (nonatomic, copy) WFDividIntoSetViewController *(^dividIntoData)(NSMutableArray <WFMyAreaDividIntoSetModel *> *models);
@property (nonatomic, copy) WFDividIntoSetViewController *(^groupIds)(NSString *groupId);
@property (nonatomic, copy) WFDividIntoSetViewController *(^chargingModelIds)(NSString *chargingModelId);
@property (nonatomic, copy) WFDividIntoSetViewController *(^sourceType)(WFDividIntoSetSourceType type);
@end

NS_ASSUME_NONNULL_END
