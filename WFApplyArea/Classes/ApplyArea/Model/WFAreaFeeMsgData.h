//
//  WFAreaFeeMsgData.h
//  AFNetworking
//
//  Created by 王宇 on 2019/9/18.
//

#import <Foundation/Foundation.h>
@class WFMyAreaListModel;

NS_ASSUME_NONNULL_BEGIN

@interface WFAreaFeeMsgData : NSObject
/**收费信息*/
@property (nonatomic, strong) NSArray <WFMyAreaListModel *> *feeData;
/**实例化*/
+ (WFAreaFeeMsgData *)shareInstace;
@end

NS_ASSUME_NONNULL_END
