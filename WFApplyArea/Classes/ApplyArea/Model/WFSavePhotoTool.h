//
//  WFSavePhotoTool.h
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/5.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFSavePhotoTool : NSObject

/**
 成功
 */
@property (nonatomic, copy) void (^savePhotoSuccessBlock)(void);
/**
 失败
 */
@property (nonatomic, copy) void (^savePhotoFailBlock)(void);

/**
 初始化

 @return WFSavePhotoTool
 */
+ (instancetype)shareInstance;

/**
 生成一个二维码
 
 @param url 传入的文办
 @param codeSize 图片大小
 @return 返回一个二维码
 */
- (UIImage *)imageWithUrl:(NSString *)url
                 codeSize:(CGFloat)codeSize;



/**
 保存图片到相册 传入的是一个 UIImage 对象
 
 @param urls 图片链接数组
 */
- (void)saveImageToAlbumWithUrls:(NSArray *)urls;

@end

NS_ASSUME_NONNULL_END
