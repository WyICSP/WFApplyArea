//
//  WFJSApiTools.m
//  AFNetworking
//
//  Created by 王宇 on 2019/8/27.
//

#import "WFJSApiTools.h"
#import "WFUserCenterPublicAPI.h"
#import "dsbridge.h"
#import "YFKeyWindow.h"
#import "UserData.h"
#import "YFToast.h"
#import "WKHelp.h"

@implementation WFJSApiTools

/**同步*/
- (NSString *)getUserId: (NSString *) msg
{
    return [UserData userInfo].uuid;
}

- (NSString *)isIphoneX: (NSString *) msg
{
    return ISIPHONEX ? @"1" : @"0";
}


/**返回*/
- (void)goBack:(NSString *)msg :(JSCallback) completionHandler
{
    [[[YFKeyWindow shareInstance] getCurrentVC].navigationController popViewControllerAnimated:YES];
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

/**联系客服*/
- (void)phoneCilck:(NSString *)msg :(JSCallback) completionHandler
{
    [WFUserCenterPublicAPI callPhoneWithNumber:msg];
    completionHandler(msg,YES);
}


@end
