//
//  WFAreaOtherSetViewController.h
//  AFNetworking
//
//  Created by 王宇 on 2019/12/24.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFAreaDetailModel;

typedef NS_ENUM(NSInteger, WFOtherSetSourceType) {
    WFOtherSetUpgradeAreaType = 0, // 升级
    WFOtherSetUpdateAreaType      // 修改片区
};

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaOtherSetViewController : YFBaseViewController
/// 片区 ID
@property (nonatomic, copy) NSString *groupId;
/// 区分来源
@property (nonatomic, assign) WFOtherSetSourceType type;
/// 数据源
@property (nonatomic, strong) WFAreaDetailModel *models;

@property (nonatomic, copy) WFAreaOtherSetViewController *(^groupIds)(NSString *groupId);
@property (nonatomic, copy) WFAreaOtherSetViewController *(^sourceType)(WFOtherSetSourceType type);
@property (nonatomic, copy) WFAreaOtherSetViewController *(^dataModels)(WFAreaDetailModel *models);
@end

NS_ASSUME_NONNULL_END
