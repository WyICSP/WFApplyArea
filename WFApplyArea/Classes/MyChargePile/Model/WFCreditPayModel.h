//
//  WFCreditPayModel.h
//  AFNetworking
//
//  Created by 王宇 on 2020/2/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFCreditPayModel : NSObject
/// 说明
@property (nonatomic, copy) NSString *advertisingLanguage;
/// 单台设备价格
@property (nonatomic, strong) NSNumber *devicePrice;
/// 总价
@property (nonatomic, assign) NSInteger money;
///  数量
@property (nonatomic, assign) NSInteger deviceNum;
/// 背景图片
@property (nonatomic, copy) NSString *pageUrl;
/// 支付方式
@property (nonatomic, strong) NSArray *creditPaymentVOList;

@end

@interface WFCreditPaymentVOListModel : NSObject
/// 图片
@property (nonatomic, copy) NSString *icon;
/// 名字
@property (nonatomic, copy) NSString *name;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;

@end

@interface WFCheditPayMothedModel : NSObject
/**支付宝支付参数*/
@property (nonatomic, copy) NSString *aliPay;
@property (nonatomic, copy) NSString *package;
/**微信APPID*/
@property (nonatomic, copy) NSString *appid;
/**appSecret*/
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *sign;
/**商户号*/
@property (nonatomic, copy) NSString *partnerid;
/**前后台约定的一个值*/
@property (nonatomic, copy) NSString *partnerKey;
/**预支付单号*/
@property (nonatomic, copy) NSString *prepayid;
@property (nonatomic, copy) NSString *noncestr;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *rechargeId;

@end

NS_ASSUME_NONNULL_END
