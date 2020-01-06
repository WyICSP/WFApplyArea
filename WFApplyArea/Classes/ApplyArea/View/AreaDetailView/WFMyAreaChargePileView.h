//
//  WFMyAreaChargePileView.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFMyAreaChargePileView : UIView
/**片区*/
@property (nonatomic, copy) NSString *groupId;
/// 编辑类型
@property (nonatomic, assign) BOOL editType;
/// 父视图
@property (nonatomic, weak) UIViewController *superVC;
/// 重置数据
@property (nonatomic, copy) void (^resetEditBlock)(void);
/// 刷新页面数据
- (void)reloadDataWithEditType:(BOOL)editType;
@end

NS_ASSUME_NONNULL_END
