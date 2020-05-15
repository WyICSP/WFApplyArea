//
//  WFShopActivityModel.h
//  AFNetworking
//
//  Created by YZC on 2019/11/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFShopActivityModel : NSObject



@property (nonatomic, strong) NSNumber *type;

/**图片地址*/
@property (nonatomic, copy) NSString *value;

@property (nonatomic, strong) NSNumber *skipType;
/**目标地址*/
@property (nonatomic, copy) NSString *target;
/**是否显示*/
@property (nonatomic, assign) BOOL open;
/**倒计时*/
@property (nonatomic, strong) NSNumber *countDown;


@end

NS_ASSUME_NONNULL_END
