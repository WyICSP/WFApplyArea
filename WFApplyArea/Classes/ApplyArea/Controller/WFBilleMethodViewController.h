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

@interface WFBilleMethodViewController : YFBaseViewController
/**片区id,如果不传则回复默认计费方式*/
@property (nonatomic, copy) NSString *groupId;
/**数据*/
@property (nonatomic, strong, nullable) WFBillMethodModel *models;
/**返回的数据*/
@property (nonatomic, copy) void (^billMethodDataBlock)(WFBillMethodModel *datas);

@property (nonatomic, copy) WFBilleMethodViewController *(^groupIds)(NSString *groupId);
@property (nonatomic, copy) WFBilleMethodViewController *(^billMethodModels)(WFBillMethodModel *datas);
@end

NS_ASSUME_NONNULL_END
