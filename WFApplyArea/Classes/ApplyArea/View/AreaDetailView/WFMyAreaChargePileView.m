//
//  WFMyAreaChargePileView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFMyAreaChargePileView.h"
#import "WFMyAreaPileListTableViewCell.h"
#import "WFMyChargePileDataTool.h"
#import "WFMyChargePileModel.h"
#import "SKSafeObject.h"
#import "WKHelp.h"

@interface WFMyAreaChargePileView ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**数据源*/
@property (nonatomic, strong, nullable) NSArray <WFSignleIntensityListModel *> *models;
@end

@implementation WFMyAreaChargePileView

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

/**
 获取信号强度
 */
- (void)getSignleIntensity {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFMyChargePileDataTool getAreaPilesignalIntensitWithParams:params resultBlock:^(NSArray<WFSignleIntensityListModel *> * _Nonnull models) {
        @strongify(self)
        self.models = models;
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.models.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMyAreaPileListTableViewCell *cell = [WFMyAreaPileListTableViewCell cellWithTableView:tableView];
    cell.model = self.models[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(10.0f);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-100.0f) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColorFromRGB(0xF5F5F5);
        _tableView.estimatedRowHeight = 80.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (void)setGroupId:(NSString *)groupId {
    _groupId = groupId;
    //获取信号强度
    [self getSignleIntensity];
}

@end
