//
//  WFShareHelpTool.h
//  WFKit
//
//  Created by 王宇 on 2019/5/8.
//  Copyright © 2019 王宇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WFSharePlatformType) {
    WFSharePlatformQQ = 0, //QQ
    WFSharePlatformWechat  // 微信
};

NS_ASSUME_NONNULL_BEGIN

@interface WFShareHelpTool : NSObject

/**
 生成一个二维码

 @param url 传入的文办
 @param codeSize 图片大小
 @return 返回一个二维码
 */
//+ (UIImage *)imageWithUrl:(NSString *)url
//                 codeSize:(CGFloat)codeSize;



/**
 保存图片到相册 传入的是一个 UIImage 对象

 @param urls 图片链接数组
 */
+ (void)saveImageToAlbumWithUrls:(NSArray *)urls;




/**
 复制文本

 @param contentText 需要复制的文本
 */
+ (void)copyByContentText:(NSString *)contentText
              resultBlock:(void(^)(void))resultBlock;




/**
 调用系统分享 有二维码的 分享到微信

 @param urls 需要分享的图片链接
 @param successBlock 分享成功
 @param failBlock 分享失败
 */
+ (void)shareImagesToWechatWithUrls:(NSArray *)urls
                       successBlock:(void(^)(void))successBlock
                          failBlock:(void(^)(void))failBlock;


/**
 调用系统分享 文本 图片

 @param shareText 分享文本
 @param shareUrl 分享链接
 @param shareImage 分享logo
 */
+ (void)shareTextBySystemWithText:(NSString *)shareText
                         shareUrl:(NSString *)shareUrl
                       shareImage:(UIImage *)shareImage;



/**
 调用分享  分享文本

 @param shareText 分享文本
 @param successBlock 分享成功
 @param failBlock 分享失败
 */
+ (void)shareTextToWechatWithText:(NSString *)shareText
                        shareType:(WFSharePlatformType)shareType
                     successBlock:(void(^)(void))successBlock
                        failBlock:(void(^)(void))failBlock;


/**
 截图

 @param contentView 所截图的 View
 @return 返回一张图片
 */
+ (UIImage *)screenshotForView:(UIView *)contentView;



///**
// 分享到微信好友
//
// @param shareType SSDKPlatformTypeWechat 微信好友 SSDKPlatformSubTypeWechatTimeline 朋友圈
// @param shareUrl 分享链接
// */
//+ (void)shareInvitationToWechatWithType:(SSDKPlatformType)shareType
//                               shareUrl:(NSString *)shareUrl;
//
//
//
//
///**
// 微信登录授权
//
// @param shareType 平台类型
// @param resultBlock 返回数据
// */
//+ (void)shareGetAuthorizationWithType:(SSDKPlatformType)shareType
//                          resultBlock:(void(^)(NSDictionary *rawData,NSString *openId))resultBlock;



@end

NS_ASSUME_NONNULL_END
