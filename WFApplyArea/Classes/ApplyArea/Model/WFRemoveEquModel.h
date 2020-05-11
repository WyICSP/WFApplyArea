//
//  WFRemoveEquModel.h
//  AFNetworking
//
//  Created by 王宇 on 2020/4/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WFRemoveEquModel : NSObject
/**id*/
@property (nonatomic, copy) NSString *address;
/**id*/
@property (nonatomic, copy) NSString *cityName;
/**id*/
@property (nonatomic, copy) NSString *groupName;
/**id*/
@property (nonatomic, strong) NSArray *cdzShellListVOS;
@end

@interface WFRemoveEquItemModel : NSObject
/**id*/
@property (nonatomic, copy) NSString *Id;
/**桩号*/
@property (nonatomic, copy) NSString *shellId;
/// 是否选中
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
