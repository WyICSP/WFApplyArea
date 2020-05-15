//
//  WFShopPublicAPI.h
//  AFNetworking
//
//  Created by YZC on 2019/11/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopPublicAPI : NSObject

/// 二维码数据
@property (nonatomic, strong) NSDictionary *qrcodeInfo;

/// 实例化
+ (instancetype)shareInstance;

/**
 打开分享页面

 @param params H5 带过来的参数
 */
- (void)openShareViewCtrlWithParams:(NSDictionary *)params;


/// 扫描二维码得到的数据
/// @param params 扫描出来的信息
- (NSDictionary *)scanQRCodeWithParams:(NSDictionary *)params;


- (void)jumpScanCtrl:(void(^)(NSDictionary *codeInfo))resultBlock;

/**跳转到提现页面*/
- (void)gotoWithdrawController:(UIViewController *)controller;

@end

NS_ASSUME_NONNULL_END
