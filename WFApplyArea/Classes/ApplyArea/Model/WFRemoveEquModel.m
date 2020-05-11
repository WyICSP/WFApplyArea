//
//  WFRemoveEquModel.m
//  AFNetworking
//
//  Created by 王宇 on 2020/4/27.
//

#import "WFRemoveEquModel.h"
#import <MJExtension/MJExtension.h>

@implementation WFRemoveEquModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"cdzShellListVOS":@"WFRemoveEquItemModel"};
}

@end


@implementation WFRemoveEquItemModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"Id":@"id"};
}

@end
