//
//  WFAbnormalPileViewController.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/20.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFAbnormalPileViewController.h"
#import "WFAbnomalListTableViewCell.h"
#import "WFMyChargePileDataTool.h"
#import "WFMyChargePileModel.h"
#import "WFAbnormalHeadView.h"
#import "SKSafeObject.h"
#import "WKHelp.h"

@interface WFAbnormalPileViewController ()<UITableViewDelegate,UITableViewDataSource>
/**tableView*/
@property (nonatomic, strong, nullable) UITableView *tableView;
/**数据*/
@property (nonatomic, strong, nullable) NSArray <WFAbnormalPileListModel *> *models;
@end

@implementation WFAbnormalPileViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

#pragma mark 私有方法
- (void)setUI {
    self.title = @"异常信息";
    self.view.backgroundColor = UIColorFromRGB(0xF5F5F5);
    [self getAbnormalPile];
}

/**
 获取异常充电桩信息
 */
- (void)getAbnormalPile {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFMyChargePileDataTool getAbnormalPileListWithParams:params resultBlock:^(NSArray<WFAbnormalPileListModel *> * _Nonnull models) {
        @strongify(self)
        self.models = models;
        [self.tableView reloadData];
    }];
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFAbnomalListTableViewCell *cell = [WFAbnomalListTableViewCell cellWithTableView:tableView];
    cell.model = self.models[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WFAbnormalHeadView *headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFAbnormalHeadView" owner:nil options:nil] firstObject];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KHeight(35);
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.rowHeight = KHeight(44.0f);
        _tableView.estimatedRowHeight = 0.0f;
        _tableView.estimatedSectionFooterHeight = 0.0f;
        _tableView.estimatedSectionHeaderHeight = 0.0f;
        _tableView.contentInset = UIEdgeInsetsMake(KHeight(10.0f), 0, 0, 0);
        _tableView.backgroundColor = UIColor.clearColor;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}



@end
