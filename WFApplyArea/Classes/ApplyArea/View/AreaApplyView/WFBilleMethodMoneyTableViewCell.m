//
//  WFBilleMethodMoneyTableViewCell.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/6.
//  Copyright © 2019 wyxlh. All rights reserved.
//

#import "WFBilleMethodMoneyTableViewCell.h"
#import "WFBilleMethodCollectionViewCell.h"
#import "UITextField+RYNumberKeyboard.h"
#import "WFBillMethodModel.h"
#import "WFUpgradeAreaData.h"
#import "UIView+Frame.h"
#import "YFKeyWindow.h"
#import "YFToast.h"
#import "WKHelp.h"

@interface WFBilleMethodMoneyTableViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong, nullable) UICollectionView *collectionView;
@property (nonatomic, strong, nullable) UITextField *moneyTF;
@end

@implementation WFBilleMethodMoneyTableViewCell

static NSString *const cellId = @"WFBilleMethodMoneyTableViewCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    WFBilleMethodMoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFBilleMethodMoneyTableViewCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//绑定数据
- (void)bindToCell:(NSArray <WFBillingPriceMethodModel *> *)models
        cellHeight:(CGFloat)cellHeight {
    self.models = models;
    self.cellHeight = cellHeight;
    [self.collectionView reloadData];
}

/**
 
 */
- (void)showCustusmAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:wenxinTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *textField = alertController.textFields.firstObject;
        if (textField.text.length == 0) return;
        [YFNotificationCenter postNotificationName:@"AddTimeKeys" object:nil userInfo:@{@"inputKeys":textField.text}];
        
    }]];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入充电金额";
        self.moneyTF = textField;
        [textField setMoneyKeyboard];
        //通过 KVC 监听 moneyTF 的 text
        [textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    }];
    
    [[[YFKeyWindow shareInstance] getCurrentVC] presentViewController:alertController animated:true completion:nil];
}

/**
 监听数据
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"text"]) {
        //监听输入框
        UITextField *textField = (UITextField *)object;
        if (textField.text.doubleValue > 99999)
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 5)];
        
        //发现包含小数点，并且小数点在倒数第三位就，如果再多就截掉。
        NSInteger loca = [textField.text rangeOfString:@"."].location;
        if (loca + 3 < textField.text.length && loca > 0) {
            textField.text = [textField.text substringToIndex:loca + 3];
        }
    }
}

#pragma mark UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WFBilleMethodCollectionViewCell *cell = [WFBilleMethodCollectionViewCell cellWithCollectionView:collectionView indexPath:indexPath];
    cell.pModel = self.models[indexPath.row];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return KHeight(10.0f);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0.0f, KWidth(12.0f), 0.0f, KWidth(12.0f));
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //将当前的转态置为相反转态
    WFBillingPriceMethodModel *model = self.models[indexPath.row];
    if ([model.billingName isEqualToString:@"其他"]) {
        //自定义金额
        [self showCustusmAction];
    }else {
        //升级片区 如果是充满自停, 老片区拥有多次收费 或者优惠收费 必须选择充满自停
        if (model.isDefault == 2 && [WFUpgradeAreaData shareInstance].isExistence && model.isSelect) {
            return;
        }
        //选中其他的数据
        model.isSelect = !model.isSelect;
        //选中的数据计数
        NSInteger selectNum = 0;
        for (WFBillingTimeMethodModel *sModel in self.models) {
            if (sModel.isSelect) {
                selectNum ++;
            }
        }
        //最多就 6 条数据
        if (selectNum > 6) {
            WFBillingPriceMethodModel *lastModel =  self.models[indexPath.row];
            lastModel.isSelect = NO;
            [YFToast showMessage:@"最多只能选择6个" inView:[[YFKeyWindow shareInstance] getCurrentVC].view];
            return;
        }
        
        //将选中的数据添加到数组中
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (WFBillingPriceMethodModel *itemModel in self.models) {
            if (itemModel.isSelect) {
                [array addObject:itemModel];
            }
        }
        //发送通知
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setValue:@(array.count) forKey:@"dataNum"];
        [YFNotificationCenter postNotificationName:@"MonitorMoneyKeys" object:nil userInfo:userInfo];
        
        [collectionView reloadData];
    }
    
}

#pragma mark get set
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((ScreenWidth-KWidth(24.0f)-KWidth(54.0f))/4, KHeight(32.0f));
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-KWidth(24.0f), self.cellHeight) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        [_collectionView registerNib:[UINib nibWithNibName:@"WFBilleMethodCollectionViewCell" bundle:[NSBundle bundleForClass:[self class]]] forCellWithReuseIdentifier:@"WFBilleMethodCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"WFBilleMethodCollectionReusableView" bundle:[NSBundle bundleForClass:[self class]]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"WFBilleMethodCollectionReusableView"];
        [_collectionView setCornerRadiusWithRoundedRect:CGRectMake(0, 0, ScreenWidth-KWidth(24.0f), self.cellHeight) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (void)dealloc {
    [self.moneyTF removeObserver:self forKeyPath:@"text"];
}

@end
