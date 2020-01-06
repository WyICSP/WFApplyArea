//
//  WFAreaFeeMsgData.h
//  AFNetworking
//
//  Created by 王宇 on 2019/9/18.
//

#import <Foundation/Foundation.h>
@class WFMyAreaListModel;
@class WFAreaDetailSingleChargeModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaFeeMsgData : NSObject
/**收费信息*/
@property (nonatomic, strong) NSArray <WFMyAreaListModel *> *feeData;
/// 每次查看的单次收费的数据, 最新的一条
@property (nonatomic, strong) NSArray <WFAreaDetailSingleChargeModel *> *singleModel;
/**实例化*/
+ (WFAreaFeeMsgData *)shareInstace;
@end

NS_ASSUME_NONNULL_END
