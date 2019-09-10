//
//  WFBilleMethodViewController.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <WFKitMain/YFBaseViewController.h>

@class WFBillMethodModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFBilleMethodSourceType) {
    WFBilleMethodApplyType = 0,//申请片区的时候
    WFBilleMethodUpdateType,   //修改片区
    WFBilleMethodUpgradeType   //升级片区
};

@interface WFBilleMethodViewController : YFBaseViewController
/**片区id,如果不传则回复默认计费方式*/
@property (nonatomic, copy) NSString *groupId;
/**数据*/
@property (nonatomic, strong, nullable) WFBillMethodModel *models;
/**来源*/
@property (nonatomic, assign) WFBilleMethodSourceType type;
/**返回的数据*/
@property (nonatomic, copy) void (^billMethodDataBlock)(WFBillMethodModel *datas);

@property (nonatomic, copy) WFBilleMethodViewController *(^groupIds)(NSString *groupId);
@property (nonatomic, copy) WFBilleMethodViewController *(^billMethodModels)(WFBillMethodModel *datas);
@property (nonatomic, copy) WFBilleMethodViewController *(^sourceType)(WFBilleMethodSourceType type);
@end

NS_ASSUME_NONNULL_END
