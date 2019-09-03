//
//  WFShareHelpTool.m
//  WFKit
//
//  Created by 王宇 on 2019/5/8.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFShareHelpTool.h"
//#import "UIImage+LXQRCode.h"
#import "YFToast.h"
#import "YFKeyWindow.h"

@implementation WFShareHelpTool

#pragma mark 生成二维码
//+ (UIImage *)imageWithUrl:(NSString *)url
//                 codeSize:(CGFloat)codeSize {
//    return [UIImage LX_ImageOfQRFromURL:url codeSize:codeSize];
//}


#pragma mark 保存图片到相册
+ (void)saveImageToAlbumWithUrls:(NSArray *)urls {
    if (urls.count == 0) return;
    NSMutableArray *photos = [NSMutableArray new];
    
    for (UIImage *url in urls) {
        [photos addObject:url];
    }
    
    dispatch_queue_t queue = dispatch_queue_create("intelligentcharge", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < photos.count; i ++) {
            UIImage *image = (UIImage *)photos[i];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if(error){
        [YFToast showMessage:@"保存图片失败" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
    }else{
        [YFToast showMessage:@"保存图片成功" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
    }
}


#pragma mark 复制文本
+ (void)copyByContentText:(NSString *)contentText
              resultBlock:(void(^)(void))resultBlock {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = contentText;
    if ([pasteboard.string isEqualToString:contentText]) {
        resultBlock();
    } else {
        [YFToast showMessage:@"复制失败" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
    }
}


#pragma mark 分享
+ (void)shareImagesToWechatWithUrls:(NSArray *)urls
                       successBlock:(void(^)(void))successBlock
                          failBlock:(void(^)(void))failBlock {
    if (urls.count == 0) return;
    
    //分享的url
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:urls applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            successBlock();
        } else  {
            failBlock();
        }
    };
}


+ (void)shareTextBySystemWithText:(NSString *)shareText
                         shareUrl:(NSString *)shareUrl
                        shareImage:(UIImage *)shareImage {
    if (shareText.length == 0) {
        return;
    }
    
    if (shareUrl.length == 0) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:shareUrl];
    NSArray *activityItemsArray = @[shareText, shareImage, url];
    
    //
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItemsArray applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];

    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
        } else  {
        }
    };
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:activityVC animated:YES completion:nil];
}


+ (void)shareTextToWechatWithText:(NSString *)shareText
                        shareType:(WFSharePlatformType)shareType
                     successBlock:(void(^)(void))successBlock
                        failBlock:(void(^)(void))failBlock {
    
    if (shareType == WFSharePlatformWechat) {
        NSURL * url = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen)
        {   //打开微信
            [[UIApplication sharedApplication] openURL:url];
        }else {
            
        }
    }else {
        NSURL * url = [NSURL URLWithString:@"mqq://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen)
        {   //打开QQ
            [[UIApplication sharedApplication] openURL:url];
        }else {
            
        }
    }
    

//shareSDK分享文本
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
//    [params SSDKSetupShareParamsByText:shareText
//                                    images:nil
//                                       url:nil
//                                     title:nil
//                                      type:SSDKContentTypeText];
//

}



#pragma mark 截图
+ (UIImage *)screenshotForView:(UIView *)contentView {
    UIImage *image = nil;
    //判断View类型（一般不是滚动视图或者其子类的话内容不会超过一屏，当然如果超过了也可以通过修改frame来实现绘制）
    if ([contentView.class isSubclassOfClass:[UIScrollView class]]) {
        UIScrollView *scrView = (UIScrollView *)contentView;
        
        CGPoint tempContentOffset = scrView.contentOffset;
        CGRect tempFrame = scrView.frame;
        
        scrView.contentOffset = CGPointZero;
        scrView.frame = CGRectMake(0, 0, scrView.contentSize.width, scrView.contentSize.height);
        
        image = [self screenshotForView:scrView size:scrView.frame.size];
        
        scrView.contentOffset = tempContentOffset;
        scrView.frame = tempFrame;
        
    } else {
        image = [self screenshotForView:contentView size:contentView.frame.size];
    }
    
    return image;
}

+ (UIImage *)screenshotForView:(UIView *)view size:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}


///**
// 分享到微信好友
//
// @param shareType SSDKPlatformTypeWechat 微信好友 SSDKPlatformSubTypeWechatTimeline 朋友圈
// @param shareUrl 分享链接
// */
//+ (void)shareInvitationToWechatWithType:(SSDKPlatformType)shareType
//                               shareUrl:(NSString *)shareUrl {
//
//    if (shareUrl.length == 0) return;
//
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//
//    [params SSDKSetupShareParamsByText:@"云智充欢迎您加入，安全充电，即停即充，共享充电，引导智能小区信潮流。"
//                                    images:[UIImage imageNamed:@"IconCode"]
//                                       url:[NSURL URLWithString:shareUrl]
//                                     title:@"云智充智能共享充电桩"
//                                      type:SSDKContentTypeWebPage];
//
//    [ShareSDK share:shareType parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//
//        switch (state) {
//            case SSDKResponseStateUpload:
//                // 分享视频的时候上传回调，进度信息在 userData
//                break;
//            case SSDKResponseStateSuccess:
//                //成功
//                [YFToast showMessage:@"分享成功" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
//                break;
//            case SSDKResponseStateFail:
//            {
//                //失败
//                [YFToast showMessage:@"分享失败" inView:[[[YFKeyWindow shareInstance] getCurrentVC] view]];
//                break;
//            }
//            case SSDKResponseStateCancel:
//                //取消
//                break;
//
//            default:
//                break;
//        }
//    }];
//}
//
///**
// 微信登录授权
//
// @param shareType 平台类型
// @param resultBlock 返回数据
// */
//+ (void)shareGetAuthorizationWithType:(SSDKPlatformType)shareType
//                          resultBlock:(void(^)(NSDictionary *rawData,NSString *openId))resultBlock {
//    [ShareSDK authorize:shareType settings:@{} onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
//        resultBlock(user.rawData,user.uid);
//    }];
//}


@end
