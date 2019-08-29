//
//  WFMyChargePileHeadView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/19.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyChargePileHeadView.h"
#import "WFMyChargePileModel.h"

@implementation WFMyChargePileHeadView

- (void)setModels:(WFMyChargePileModel *)models {
    self.pileCount.text = [NSString stringWithFormat:@"%ld台",models.count];
    NSString *present = @"%";
    self.rate.text = [NSString stringWithFormat:@"%.2f%@",models.usage,present];
}

@end
