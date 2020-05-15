//
//  WFWithdrawModel.h
//  AFNetworking
//
//  Created by YZC on 2019/11/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**用户绑定信息*/
@interface WFWithdrawModel : NSObject
/**可提现(元)*/
@property (nonatomic, copy) NSString *tips;
/**钱包余额*/
@property (nonatomic, strong) NSNumber *money;
/**提现额度不足提示(最低提现10元哦~)*/
@property (nonatomic, copy) NSString *settleTips;
/**手机号*/
@property (nonatomic, copy) NSString *mobile;
/**最小提现金额*/
@property (nonatomic,copy) NSString *minTransfer;
/**绑定的提现渠道列表 (对象 支付宝 微信 余额 )   */
@property (nonatomic, strong) NSArray *channelList;


@end

/**具体绑定的信息*/
@interface WFWithdrawdChannelDetailModel : NSObject
/**渠道编号*/
@property (nonatomic, assign) NSInteger type;
/**渠道名称*/
@property (nonatomic, copy) NSString *channelName;
/**渠道图标*/
@property (nonatomic, copy) NSString *imgUrl;
/**绑定状态*/
@property (nonatomic, assign) BOOL binding;
/**账号*/
@property (nonatomic, copy) NSString *accountName;
/**名称*/
@property (nonatomic, copy) NSString *userName;

@end


NS_ASSUME_NONNULL_END
