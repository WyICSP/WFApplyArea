//
//  WFShopMallShareTool.h
//  AFNetworking
//
//  Created by 王宇 on 2019/10/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopMallShareTool : NSObject

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
 截图

 @param contentView 所截图的 View
 @return 返回一张图片
 */
+ (UIImage *)screenshotForView:(UIView *)contentView;

@end

NS_ASSUME_NONNULL_END
