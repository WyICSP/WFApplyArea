//
//  WFGatewayListModel.h
//  AFNetworking
//
//  Created by 王宇 on 2019/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFGatewayListModel : NSObject
/// 网关ID
@property (nonatomic, copy) NSString *gateWayId;
/// 网关编号
@property (nonatomic, copy) NSString *gateWayCode;
/// 网关下所有的子设备数
@property (nonatomic, assign) NSInteger count;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;
/// 充电桩 id
@property (nonatomic, strong) NSArray *loraChargeVOList;
/// 是否打开
@property (nonatomic, assign) BOOL isOpen;

@end

@interface WFGatewayLoarListModel : NSObject
/// 充电桩id
@property (nonatomic, copy) NSString *chargeId;
/// 充电桩编号
@property (nonatomic, copy) NSString *cdzCode;
/// 充电桩字母编号
@property (nonatomic, copy) NSString *letter;
/// 子设备状态
@property (nonatomic, strong) NSArray *socketParamVOList;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;
/// 是否打开
@property (nonatomic, assign) BOOL isOpen;
@end

@interface WFFindAllGateWayModel : NSObject
/// 充电桩字母编号
@property (nonatomic, copy) NSString *gateWayId;
/// 充电桩字母编号
@property (nonatomic, copy) NSString *code;
@end

//@interface WFSocketParamVOListModel : NSObject
///// 编号
//@property (nonatomic, assign) NSInteger socketNo;
///// 1 未充电 2 标识在充电
//@property (nonatomic, assign) NSInteger status;
//@end

NS_ASSUME_NONNULL_END
