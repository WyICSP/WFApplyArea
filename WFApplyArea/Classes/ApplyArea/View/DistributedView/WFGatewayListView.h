//
//  WFGatewayListView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/21.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFGatewayListView : UIView
/// 0 的时候不可选中, 1 的时候可以选中
@property (nonatomic, assign) NSInteger index;
/// 片区 Id
@property (nonatomic, copy) NSString *groupId;
/// 重置数据
@property (nonatomic, copy) void (^resetEditBlock)(void);
/// 初始化
/// @param groupId 片区 id
- (instancetype)initWithGroupId:(NSString *)groupId;
@end

NS_ASSUME_NONNULL_END
