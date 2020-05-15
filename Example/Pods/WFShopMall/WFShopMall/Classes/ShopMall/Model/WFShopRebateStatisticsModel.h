//
//  WFShopRebateStatisticsModel.h
//  AFNetworking
//
//  Created by YZC on 2019/11/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopRebateStatisticsModel : NSObject
/**标题 特惠返利统计*/
@property (nonatomic, copy) NSString *partnerButtonTitle;
/**跳转h5链接*/
@property (nonatomic, copy) NSString *partnerRebateRecodeUrl;
/**当前模块开关*/
@property (nonatomic, assign) BOOL partnerHasRebate;
/**我的收益 是否隐藏 */
@property (nonatomic,assign) BOOL hasPartnerEarnings;
/**我的收益 标题*/
@property (nonatomic, copy) NSString *partnerEarnings;
@end

NS_ASSUME_NONNULL_END
