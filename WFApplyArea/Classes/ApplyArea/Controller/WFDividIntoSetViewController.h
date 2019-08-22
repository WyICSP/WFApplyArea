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

@interface WFDividIntoSetViewController : YFBaseViewController
/**数据*/
@property (nonatomic, strong) NSMutableArray <WFMyAreaDividIntoSetModel *> *models;
/**填写的数据*/
@property (nonatomic, copy) void (^dividIntoDataBlock)(NSArray <WFMyAreaDividIntoSetModel *> *models);
/**片区 Id*/
@property (nonatomic, copy) NSString *groupId;
/**chargingModelId*/
@property (nonatomic, copy) NSString *chargingModelId;

@property (nonatomic, copy) WFDividIntoSetViewController *(^dividIntoData)(NSMutableArray <WFMyAreaDividIntoSetModel *> *models);
@property (nonatomic, copy) WFDividIntoSetViewController *(^groupIds)(NSString *groupId);
@property (nonatomic, copy) WFDividIntoSetViewController *(^chargingModelIds)(NSString *chargingModelId);
@end

NS_ASSUME_NONNULL_END
