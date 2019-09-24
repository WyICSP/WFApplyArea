//
//  WFUserCenterPublicAPI.m
//  AFNetworking
//
//  Created by 王宇 on 2019/8/27.
//

#import "WFUserCenterPublicAPI.h"
#import <TZImagePickerController/TZImagePickerController.h>
#import "WFEditAreaAddressViewController.h"
#import "WFMyChargePileDataTool.h"
#import "YFMediatorManager+WFUser.h"
#import "JMUpdataImage.h"
#import "YFKeyWindow.h"
#import "UserData.h"
#import "WKHelp.h"

@implementation WFUserCenterPublicAPI

/**打开相册*/
+ (void)openSystemAlbumWithType:(WFUpdatePhotoType)type
                    resultBlock:(void (^)(NSString *photoData))resultBlock {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    // 你可以通过block或者代理，来得到用户选择的照片.
    @weakify(self)
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self)
        UIImage *image = [photos firstObject];
        NSData *data = UIImageJPEGRepresentation(image, 0.1f);
        NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        
        if (type == WFUpdatePhotoFeedbackType) {
//            [self upLoadPhotoWithImageString:encodedImageStr photoImage:image successBlock:^(NSString *str) {
//                resultBlock(str);
//            }];
        }else {
            [self upLoadModHeadImageWithParams:encodedImageStr successBlock:^(NSString *str) {
                resultBlock(str);
            }];
        }
    }];
    
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:imagePickerVc animated:YES completion:nil];
}


/**打开相机*/
+ (void)openSystemCameraWithType:(WFUpdatePhotoType)type
                     resyltBlock:(void (^)(NSString *photoData))resultBlock {
    JMUpdataImage *update = [[JMUpdataImage alloc] init];
    [update camera:[[YFKeyWindow shareInstance] getCurrentVC]];
    @weakify(self)
    update.callBackImage = ^(NSString *data,UIImage *image){
        @strongify(self)
        if (type == WFUpdatePhotoFeedbackType) {
//            [self upLoadPhotoWithImageString:data photoImage:image successBlock:^(NSString *str) {
//                resultBlock(str);
//            }];
        }else {
            [self upLoadModHeadImageWithParams:data successBlock:^(NSString *str) {
                resultBlock(str);
            }];
        }
        
    };
}

/**
 上传图片
 
 @param imgString 图片
 @param successBlock 上传成功
 */
+ (void)upLoadModHeadImageWithParams:(NSString *)imgString
                        successBlock:(void(^)(NSString *str))successBlock {
    NSMutableDictionary *parms = [NSMutableDictionary dictionary];
    [parms setValue:imgString forKey:@"img"];
    [parms setValue:USER_UUID forKey:@"uuid"];
    [WFMyChargePileDataTool uploadModHeadWithParams:parms resultBlock:^(NSString * _Nonnull str) {
        successBlock(str);
    }];
}

/**
 打电话
 
 @param phone 电话号码
 */
+ (void)callPhoneWithNumber:(NSString *)phone {
    NSString *phoneNum = [NSString stringWithFormat:@"tel:%@",phone];
    if (phone.length != 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNum]];
    }
}

/**
 退出登录 跳转登录页面
 */
+ (void)loginOutAndJumpLogin {
    //退出登录
    [UserData userInfo:nil];
    //跳转登录
    [YFMediatorManager loginOutByOpenLoginCtrl];
}

/**
 升级片区
 
 @param groupId 片区 Id
 */
+ (void)upgradeAreaWithGroupId:(NSString *)groupId {
    WFEditAreaAddressViewController *edit = [[WFEditAreaAddressViewController alloc] initWithNibName:@"WFEditAreaAddressViewController" bundle:[NSBundle bundleForClass:[self class]]];
    edit.sourceType(WFEditAddressAreauUpgradeType).areaGroupId(groupId);
    [[[YFKeyWindow shareInstance] getCurrentVC].navigationController pushViewController:edit animated:YES];
}



@end
