//
//  WFShopMallSearchViewController.m
//  WFKit
//
//  Created by 王宇 on 2019/6/21.
//  Copyright © 2019 王宇. All rights reserved.
//

#import "WFShopMallSearchViewController.h"
#import "WFShopSearchItemCollectionViewCell.h"
#import "WFShopSearchCollectionReusableView.h"
#import "WFProductListViewController.h"
#import "WFCollectionViewFlowLayout.h"
#import "WFShopSearchBarView.h"
#import "WFHistoryAddressModel.h"
#import "UIView+Frame.h"

#import "YFToast.h"
#import "WKHelp.h"

@interface WFShopMallSearchViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**collectionView*/
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
/**搜索框*/
@property (nonatomic, strong, nullable) WFShopSearchBarView *searchBar;
/**单元 cell*/
@property (nonatomic, strong, nullable) WFShopSearchItemCollectionViewCell *cell;
/**数据*/
@property (nonatomic, strong, nullable) NSArray *models;
@end

@implementation WFShopMallSearchViewController

#pragma mark 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.searchBar.searchTF becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark 私有方法
- (void)setUI {
    self.models = [[WFHistoryAddressModel shareInstance] readData];
    [self.collectionView reloadData];
}

/**
 跳转到商品列表

 @param searchKeys 搜索关键字
 */
- (void)jumpProductListWithKeys:(NSString *)searchKeys {
    WFProductListViewController *list = [[WFProductListViewController alloc] init];
    list.searchKeys = searchKeys;
    @weakify(self)
    list.goBackSearchkeysBlock = ^(NSString * _Nonnull keys) {
        @strongify(self)
        self.searchBar.searchTF.text = keys;
    };
    [self.navigationController pushViewController:list animated:YES];
}

/**
 搜索框处理

 @param cancel 返回标志
 @param searchKeys 搜索关键字
 */
- (void)searchMsgWithCancel:(BOOL)cancel searchKey:(NSString *)searchKeys {
    if (cancel) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        if (searchKeys.length == 0) {
            [YFToast showMessage:@"请输入搜索关键字" inView:self.view];
            return;
        }
        NSMutableArray *searchData = [[NSMutableArray alloc] init];
        [searchData addObject:searchKeys];
        [[WFHistoryAddressModel shareInstance] saveData:searchData];
        //获取数据
        self.models = [[WFHistoryAddressModel shareInstance] readData];
        [self.collectionView reloadData];
        //跳转到商品列表
        [self jumpProductListWithKeys:searchKeys];
    }
}

/**
 提示框
 */
- (void)alert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认删除全部历史记录?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteHidtoryRecord];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:confirm];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 删除搜索历史记录
 */
- (void)deleteHidtoryRecord {
    [[WFHistoryAddressModel shareInstance] deleteData];
    self.models = @[];
    [self.collectionView reloadData];
}

#pragma mark  UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFShopSearchItemCollectionViewCell *cell = [WFShopSearchItemCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.searchKey = self.models[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.models.count > 0) {
        return [WFShopSearchItemCollectionViewCell getSizeWithText:self.models[indexPath.row]];
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        WFShopSearchCollectionReusableView *headView = [WFShopSearchCollectionReusableView reusableViewWithCollectionView:collectionView indexPath:indexPath];
        headView.deleteBtn.hidden = headView.title.hidden = self.models.count == 0;
        @weakify(self)
        headView.deleteHistoryRecordBlock = ^{
            @strongify(self)
            [self alert];
        };
        return headView;
    }
    return [UICollectionReusableView new];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return  CGSizeMake(ScreenWidth, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self jumpProductListWithKeys:self.models[indexPath.row]];
}

#pragma mark get set
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        WFCollectionViewFlowLayout *layout = [[WFCollectionViewFlowLayout alloc]init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.searchBar.maxY, ScreenWidth, ScreenHeight-NavHeight-TabbarHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.alwaysBounceVertical = YES;
        [_collectionView registerNib:[UINib nibWithNibName:@"WFShopSearchItemCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"WFShopSearchItemCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"WFShopSearchCollectionReusableView" bundle:[NSBundle bundleForClass:[self class]]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WFShopSearchCollectionReusableView"];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (WFShopSearchBarView *)searchBar {
    if (!_searchBar) {
        _searchBar = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFShopSearchBarView" owner:nil options:nil] firstObject];
        _searchBar.frame = CGRectMake(0, 0, ScreenWidth, NavHeight);
        _searchBar.searchTF.text = self.searchKeys.length == 0 ? @"" : self.searchKeys;
        @weakify(self)
        _searchBar.searchProductsBlock = ^(BOOL isCancel, NSString * _Nonnull keys) {
            @strongify(self)
            [self searchMsgWithCancel:isCancel searchKey:keys];
        };
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

@end
