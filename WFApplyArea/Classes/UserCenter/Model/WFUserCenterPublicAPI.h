//
//  WFUserCenterPublicAPI.h
//  AFNetworking
//
//  Created by 王宇 on 2019/8/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, WFUpdatePhotoType) {
    WFUpdatePhotoFeedbackType = 0,//意见反馈
    WFUpdatePhotoModHeadType//修改头像
};

@interface WFUserCenterPublicAPI : NSObject

/**
 打开相册
 */
+ (void)openSystemAlbumWithType:(WFUpdatePhotoType)type
                    resultBlock:(void (^)(NSString *photoData))resultBlock;


/**
 打开相机
 */
+ (void)openSystemCameraWithType:(WFUpdatePhotoType)type
                     resyltBlock:(void (^)(NSString *photoData))resultBlock;

/**
 打电话
 @param phone 电话号码
 */
+ (void)callPhoneWithNumber:(NSString *)phone;

/**
 退出登录 跳转登录页面
 */
+ (void)loginOutAndJumpLogin;


@end

NS_ASSUME_NONNULL_END
