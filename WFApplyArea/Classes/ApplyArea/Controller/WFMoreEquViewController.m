//
//  WFMoreEquViewController.m
//  AFNetworking
//
//  Created by 王宇 on 2020/4/24.
//

#import "WFMoreEquViewController.h"
#import "WFMoveEquItemTableViewCell.h"
#import "UIButton+GradientLayer.h"
#import "WFMoveEquSectionView.h"
#import "WFApplyAreaDataTool.h"
#import "WFMoveEquHeadView.h"
#import "WFRemoveEquModel.h"
#import "WKConfig.h"

@interface WFMoreEquViewController ()<UITableViewDelegate,UITableViewDataSource>
/// tableView
@property (nonatomic, strong, nullable) UITableView *tableView;
/// headView
@property (nonatomic, strong, nullable) WFMoveEquHeadView *headView;
/// sectionView
@property (nonatomic, strong, nullable) WFMoveEquSectionView *sectionView;
/// 数据源
@property (nonatomic, strong, nullable) WFRemoveEquModel *models;
/// 搜索
@property (nonatomic, strong, nullable) WFRemoveEquModel *sModels;
/// 确认移入
@property (nonatomic, strong, nullable) UIView *bottomView;
/// 是否是搜索
@property (nonatomic, assign) BOOL isSearch;
@end

@implementation WFMoreEquViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)setUI {
    self.title = @"移入设备";
    self.view.backgroundColor = UIColor.whiteColor;    
    [self getCanEquDataWithSearckKey:@""];
}

/// 获取数据
- (void)getCanEquDataWithSearckKey:(NSString *)serchKey {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:serchKey forKey:@"param"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool getGroupCanEquWithParams:params resultBlock:^(WFRemoveEquModel * _Nonnull models) {
        @strongify(self)
        if (self.isSearch) {
            self.sModels = models;
        } else {
            self.models = models;
        }
        [self.tableView reloadData];
    }];
}

/// 移入设备
- (void)removeEqu:(UIButton *)sender {
    
    NSMutableArray *sIds = [[NSMutableArray alloc] initWithCapacity:0];
    for (WFRemoveEquItemModel *model in (self.isSearch ? self.sModels.cdzShellListVOS : self.models.cdzShellListVOS)) {
        if (model.isSelect)
        [sIds addObject:model.Id];
    }
    
    if (sIds.count == 0) {
        [YFToast showMessage:@"请选择充电桩" inView:self.view];
        return;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:sIds forKey:@"chargingIdList"];
    [params safeSetObject:self.groupId forKey:@"groupId"];
    @weakify(self)
    [WFApplyAreaDataTool removeEquWithParams:params resultBlock:^{
        @strongify(self)
        [self removeSuccess];
    }];
}

- (void)removeSuccess {
    self.isSearch = NO;
    self.sectionView.textField.text = @"";
    [YFToast showMessage:@"移入成功" inView:self.view];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getCanEquDataWithSearckKey:@""];
    });
    
}

#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isSearch ? self.sModels.cdzShellListVOS.count : self.models.cdzShellListVOS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WFMoveEquItemTableViewCell *cell = [WFMoveEquItemTableViewCell cellWithTableView:tableView];
    cell.model = self.isSearch ? [self.sModels.cdzShellListVOS safeObjectAtIndex:indexPath.row] : [self.models.cdzShellListVOS safeObjectAtIndex:indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 90.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MAX;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WFRemoveEquItemModel *itemModel = self.isSearch ? [self.sModels.cdzShellListVOS safeObjectAtIndex:indexPath.row] : [self.models.cdzShellListVOS safeObjectAtIndex:indexPath.row];
    itemModel.isSelect = !itemModel.isSelect;
    
    [tableView reloadData];
}

#pragma mark get set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-NavHeight-60-SafeAreaBottom) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.0f;
        _tableView.tableHeaderView = self.headView;
        [self.view addSubview:_tableView];
        [self.view addSubview:self.bottomView];
    }
    return _tableView;
}

/// headView
- (WFMoveEquHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMoveEquHeadView" owner:nil options:nil] firstObject];
        _headView.model = self.models;
    }
    return _headView;
}

- (WFMoveEquSectionView *)sectionView {
    if (!_sectionView) {
        _sectionView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFMoveEquSectionView" owner:nil options:nil] firstObject];
        @weakify(self)
        _sectionView.searchResultBlock = ^(NSString * _Nonnull searchKeys) {
            @strongify(self)
            if (searchKeys.length == 0) {
                self.isSearch = NO;
                [self.tableView reloadData];
            } else {
                self.isSearch = YES;
                [self getCanEquDataWithSearckKey:searchKeys];
            }
        };
    }
    return _sectionView;
}

///bottomView
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-60-NavHeight-SafeAreaBottom, ScreenWidth, 60)];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10.0f)];
        lbl.backgroundColor = UIColorFromRGB(0xF5F5F5);
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15, 17.5, ScreenWidth-30, 40.0f)];
        [btn addTarget:self action:@selector(removeEqu:) forControlEvents:UIControlEventTouchUpInside];
        [btn setGradientLayerWithColors:@[UIColorFromRGB(0xFF6D22),UIColorFromRGB(0xFF7E3D)] cornerRadius:20.0f gradientType:WFButtonGradientTypeLeftToRight];
        [btn setTitle:@"确定移入" forState:0];
        [_bottomView addSubview:lbl];
        [_bottomView addSubview:btn];
    }
    return _bottomView;
}

@end
