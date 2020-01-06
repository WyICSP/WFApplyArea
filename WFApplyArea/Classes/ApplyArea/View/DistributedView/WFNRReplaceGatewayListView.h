//
//  WFNRReplaceGatewayListView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WFFindAllGateWayModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFNRReplaceGatewayListView : UIView <UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// contentsView
@property (weak, nonatomic) IBOutlet UIView *contentsView;
/// 替换数据
@property (nonatomic, strong) NSArray <WFFindAllGateWayModel *> *models;
/// 替换网关 id 和名字
@property (nonatomic, copy) void (^replaceGatewayBlock)(NSString *gatewayId, NSString *gatewayName);
@end

NS_ASSUME_NONNULL_END
