//
//  YFMediatorManager+WFShopMall.h
//  WFShopMall_Example
//
//  Created by 王宇 on 2019/10/14.
//  Copyright © 2019 wyxlh. All rights reserved.
//


#import <WFBasics/YFMediatorManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface YFMediatorManager (WFShopMall)

/// 微信分享
/// @param webpageUrl 网址
/// @param title title
/// @param description 描述
/// @param thumbImageName logo 图片
/// @param scnce 分享途径 0 是好友 1 朋友圈
+ (void)shareWechatWithWebpageUrl:(NSString *)webpageUrl
                            title:(NSString *)title
                      description:(NSString *)description
                   thumbImage:(UIImage *)thumbImage
                            scnce:(NSInteger)scnce;

//+ ()

@end

NS_ASSUME_NONNULL_END
