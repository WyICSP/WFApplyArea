//
//  WFMoveEquHeadView.m
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import "WFMoveEquHeadView.h"
#import "WFRemoveEquModel.h"

@implementation WFMoveEquHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(WFRemoveEquModel *)model {
    self.name.text = model.groupName;
    self.cityName.text = model.cityName;
    self.address.text = model.address;
}

@end
