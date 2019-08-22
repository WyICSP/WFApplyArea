//
//  WFAreaDetailManyTimesTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/9.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAreaDetailManyTimesTableViewCell.h"
#import "WFDiscountItemTableViewCell.h"
#import "WFAreaDetailModel.h"
#import "WKHelp.h"

@interface WFAreaDetailManyTimesTableViewCell()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, nullable) UITableView *tableView;
@end

@implementation WFAreaDetailManyTimesTableViewCell

static NSString *const cellId = @"WFAreaDetailManyTimesTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFAreaDetailManyTimesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAreaDetailManyTimesTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    SKViewsBorder(self.bgView, 0, 0.5, UIColorFromRGB(0xE4E4E4));
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModels:(NSArray<WFAreaDetailMultipleModel *> *)models {
    _models = models;
    if (models.count != 0) {
        WFAreaDetailMultipleModel *itemModel = models.firstObject;
        self.leftLbl.text = itemModel.chargeType == 0 ? @"统一收费" : @"功率收费";
        [self.tableView reloadData];
    }
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFDiscountItemTableViewCell *cell = [WFDiscountItemTableViewCell cellWithTableView:tableView];
    cell.model = self.models[indexPath.row];
    return cell;
}

#pragma mark get set
/**
 tableView

 @return  总共把 contentsView 分为了 7份,按照 1.5:1:1 的比例分配就是 3:2:2
 */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-44-(ScreenWidth-44)/7*1.5, 37*self.models.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 37.0f;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
        [self.contentsView addSubview:_tableView];
    }
    return _tableView;
}

@end
