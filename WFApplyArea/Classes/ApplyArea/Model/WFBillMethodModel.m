//
//  WFBillMethodModel.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/14.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBillMethodModel.h"
#import <MJExtension/MJExtension.h>

@implementation WFBillMethodModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"billingTimeMethods":@"WFBillingTimeMethodModel",
             @"billingPriceMethods":@"WFBillingPriceMethodModel"};
}

@end

@implementation WFBillingTimeMethodModel


@end

@implementation WFBillingPriceMethodModel


@end
