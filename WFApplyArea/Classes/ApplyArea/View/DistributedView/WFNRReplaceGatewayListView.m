//
//  WFNRReplaceGatewayListView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/10/22.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFNRReplaceGatewayListView.h"
#import "WFNRGatewayTableViewCell.h"
#import "WFGatewayListModel.h"
#import "UIView+Frame.h"
#import "WKHelp.h"

@implementation WFNRReplaceGatewayListView

- (void)awakeFromNib {
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    [self setUI];
}

- (void)setUI {
    self.tableView.rowHeight = 45.0f;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = 0;
    self.contentsView.layer.cornerRadius = 10.0f;
}

#pragma mark - 让视图消失的方法
//解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:self];
    if (point.y < ScreenHeight) {
        return YES;
    }
    return NO;
}

- (void)tapClick:(UITapGestureRecognizer*)tap
{
    [self disappear];
}

- (void)disappear
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundColor = [UIColor clearColor];
        self.y = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark  UITableViewDataSource,UITableViewDelegateU
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFNRGatewayTableViewCell *cell = [WFNRGatewayTableViewCell cellWithTableView:tableView];
    cell.title.text = [self.models[indexPath.row] code];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self disappear];
    //返回网关 ID
    WFFindAllGateWayModel *model = self.models[indexPath.row];
    !self.replaceGatewayBlock ? : self.replaceGatewayBlock(model.gateWayId,model.code);
}


@end
