//
//  WFJSApiTools.m
//  AFNetworking
//
//  Created by 王宇 on 2019/8/27.
//

#import "WFJSApiTools.h"
#import "WFUserCenterPublicAPI.h"
#import "WKTabbarController.h"
#import "YFMediatorManager+WFUser.h"
#import "WFShareHelpTool.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "dsbridge.h"
#import "YFKeyWindow.h"
#import "UserData.h"
#import "YFToast.h"
#import "WKHelp.h"

@implementation WFJSApiTools

/**同步*/
- (NSString *)getUUID: (NSString *) msg
{
    return [UserData userInfo].uuid;
}

- (NSString *)isIphoneX: (NSString *) msg
{
    return ISIPHONEX ? @"1" : @"0";
}

- (void)getToken:(NSString *)msg :(JSCallback) completionHandler
{
    completionHandler([UserData userInfo].token,YES);
}

/**返回*/
- (void)goBack:(NSString *)msg :(JSCallback) completionHandler
{
    [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popViewControllerAnimated:YES];
    completionHandler(msg,YES);
    
}

/**返回*/
- (void)goBackToRoot:(NSString *)msg :(JSCallback) completionHandler
{
    [YFNotificationCenter postNotificationName:@"reloadServiceKeys" object:nil];
    NSArray *controllers = [WKTabbarController shareInstance].selectedViewController.childViewControllers;
    if (controllers.count != 0) {
        UIViewController *controller = controllers.lastObject;
        [controller.navigationController popToRootViewControllerAnimated:YES];
    }
    completionHandler(msg,YES);
    
}

/**上传头像 点击拍照*/
- (void)getHeadImage:(NSString *)msg :(JSCallback) completionHandler
{
    [WFUserCenterPublicAPI openSystemCameraWithType:WFUpdatePhotoModHeadType resyltBlock:^(NSString * _Nonnull photoData) {
        completionHandler(photoData,YES);
    }];
}

/**上传头像 点击相册*/
- (void)upLoadHeadImage:(NSString *)msg :(JSCallback) completionHandler
{
    [WFUserCenterPublicAPI openSystemAlbumWithType:WFUpdatePhotoModHeadType resultBlock:^(NSString * _Nonnull photoData) {
        completionHandler(photoData,YES);
    }];
}

/// 新版上传头像
- (void)upLoadImg:(NSString *)msg :(JSCallback) completionHandler
{
    NSDictionary *dict = (NSDictionary *)msg;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *type = [NSString stringWithFormat:@"%@",[dict safeJsonObjForKey:@"params"]];
        if ([type isEqualToString:@"camera"]) {
            // 拍照
            [WFUserCenterPublicAPI openSystemCameraWithType:WFUpdatePhotoFeedbackType resyltBlock:^(NSString * _Nonnull photoData) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params safeSetObject:@(YES) forKey:@"success"];
                [params safeSetObject:photoData forKey:@"data"];
                NSString *result = [NSString dictionTransformationJson:params];
                completionHandler(result,YES);
            }];
        } else {
            // 相机
            [WFUserCenterPublicAPI openSystemAlbumWithType:WFUpdatePhotoFeedbackType resultBlock:^(NSString * _Nonnull photoData) {
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params safeSetObject:@(YES) forKey:@"success"];
                [params safeSetObject:photoData forKey:@"data"];
                NSString *result = [NSString dictionTransformationJson:params];
                completionHandler(result,YES);
            }];
        }
        
    }
}

/**联系客服*/
- (void)phoneCilck:(NSString *)msg :(JSCallback) completionHandler
{
    [WFUserCenterPublicAPI callPhoneWithNumber:msg];
    completionHandler(msg,YES);
}

/**退出登录 跳转到登录页面*/
- (void)dsBLoginOut:(NSString *)msg :(JSCallback) completionHandler
{
    [WFUserCenterPublicAPI loginOutAndJumpLogin];
    completionHandler(msg,YES);
}

/**分享微信好友*/
- (void)shareWeixin:(NSString *)msg :(JSCallback) completionHandler
{
    if (msg.length != 0) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:msg]]];
        [WFShareHelpTool shareImagesToWechatWithUrls:@[image] successBlock:^{} failBlock:^{}];
    }
    completionHandler(msg,YES);
}

/**分享朋友圈*/
- (void)shareCircle:(NSString *)msg :(JSCallback) completionHandler
{
    if (msg.length != 0) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:msg]]];
        [WFShareHelpTool shareImagesToWechatWithUrls:@[image] successBlock:^{} failBlock:^{}];
    }
    completionHandler(msg,YES);
}

/**复制 url*/
- (void)copyUrl:(NSString *)msg :(JSCallback) completionHandler
{
    if (msg.length != 0) {
//        @weakify(self)
        [WFShareHelpTool copyByContentText:msg resultBlock:^{
//            @strongify(self)
            [YFToast showMessage:@"复制成功" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
        }];
    }
    completionHandler(msg,YES);
}

/**下载图片*/
- (void)saveImg:(NSString *)msg :(JSCallback) completionHandler
{
    if (msg.length != 0) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:msg]]];
        [WFShareHelpTool saveImageToAlbumWithUrls:@[image]];
    }
    completionHandler(msg,YES);
}

///**分享领取优惠券*/
- (void)shareWeixinUrl:(NSString *)msg :(JSCallback) completionHandler
{
    if (msg.length != 0) {
        [WFShareHelpTool shareTextBySystemWithText:@"领取充电券" shareUrl:msg shareImage:[UIImage imageNamed:@"shareIcon"]];
    }
    completionHandler(msg,YES);
}

///升级片区
- (void)upgradeArea:(NSString *)msg
{
    [WFUserCenterPublicAPI upgradeAreaWithGroupId:msg];
}

- (void)changePassword:(NSString *)msg :(JSCallback) completionHandler {
    [WFUserCenterPublicAPI changePassword];
    completionHandler(msg,YES);
}


#pragma mark 老商城 JS 方法
/**扫描二维码*/
- (void)scanQRCode:(NSDictionary *)msg :(JSCallback) completionHandler
{
//    completionHandler(@"",YES);
    [YFMediatorManager scanQRCode];
//    [[WFShopPublicAPI shareInstance] jumpScanCtrl:^(NSDictionary * _Nonnull codeInfo) {
//        [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popViewControllerAnimated:NO];
//        completionHandler(,YES);
//    }];scanQRCode
}

/** 获取版本号*/
- (NSString *)getAppVersion:(NSString *)msg {
    return APP_VERSION;
}

/**UUID*/
- (NSString *)getUserId:(NSString *)msg {
    return [UserData userInfo].uuid;
}

/**分享*/
- (void)openProfit:(NSDictionary *)msg :(JSCallback) completionHandler
{
    [YFMediatorManager openShareWithParams:msg];
    completionHandler(@"",YES);
    
}

/**跳转到提现页面*/
- (void)gotoWithdrawController:(NSString *)msg :(JSCallback) completionHandler{
    NSArray *controllers = [WKTabbarController shareInstance].selectedViewController.childViewControllers;
    if (controllers.count != 0) {
        UIViewController *controller = controllers.lastObject;
        [YFMediatorManager gotoWithdrawController:controller];
    }
    completionHandler(msg,YES);
    
}

@end
