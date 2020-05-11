//
//  WFMoveEquItemTableViewCell.m
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import "WFMoveEquItemTableViewCell.h"
#import "WFRemoveEquModel.h"

@implementation WFMoveEquItemTableViewCell

static NSString *const cellId = @"WFMoveEquItemTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFMoveEquItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMoveEquItemTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(WFRemoveEquItemModel *)model {
    self.title.text = model.shellId;
    self.btn.selected = model.isSelect;
}

@end
