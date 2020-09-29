//
//  WFAddVipCountPickView.m
//  WFApplyArea_Example
//
//  Created by 王宇 on 2019/8/13.
//  Copyright © 2019 wyxlh. All rights reserved.
//
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define windowColor  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define navigationViewHeight 45.0f
#define pickViewViewHeight 213.0f

#import "WFAddVipCountPickView.h"

@interface WFAddVipCountPickView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *bottomView;//包括导航视图和地址选择视图
@property (nonatomic, strong) UIPickerView *pickView;//地址选择视图
@property (nonatomic, strong) UIView *navigationView;//上面的导航视图
@property (nonatomic, strong) NSMutableArray *dataArray;//数据
@property (nonatomic, copy) NSString *defaulCount;//默认
@end

@implementation WFAddVipCountPickView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        [self addTapGestureRecognizerToSelf];
        [self createView];
    }
    return self;
}

-(void)addTapGestureRecognizerToSelf {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenBottomView)];
    [self addGestureRecognizer:tap];
}
- (void)createView {
    
    //添加数据
    self.dataArray = [[NSMutableArray alloc] init];;
    for (int i = 1; i <= 50; i ++) {
        [self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    self.defaulCount = [self.dataArray firstObject];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight)];
    [self addSubview:_bottomView];
    //导航视图
    _navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, navigationViewHeight)];
    _navigationView.backgroundColor = [UIColor whiteColor];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(0, navigationViewHeight-0.5, kScreenWidth, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:222.0/255.0 green:222.0/255.0 blue:222.0/255.0 alpha:1];
    [_navigationView addSubview:line];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 80, navigationViewHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:[UIColor colorWithWhite:0.267 alpha:1.000] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(hiddenBottomView) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:cancelBtn];
    
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(kScreenWidth - 80, 0, 80, navigationViewHeight);
    [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sureBtn setTitleColor:[UIColor colorWithRed:247.0/255.0 green:133.0/255.0 blue:86.0/255.0 alpha:1] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationView addSubview:sureBtn];
    
    
    [_bottomView addSubview:_navigationView];
    //这里添加空手势不然点击navigationView也会隐藏,
    UITapGestureRecognizer *tapNavigationView = [[UITapGestureRecognizer alloc]initWithTarget:self action:nil];
    [_navigationView addGestureRecognizer:tapNavigationView];
    
    _pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_navigationView.frame), kScreenWidth, pickViewViewHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.dataSource = self;
    _pickView.delegate =self;
    
    [_bottomView addSubview:_pickView];
    [self showBottomView];
}

#pragma mark - 确定按钮点击
-(void)tapButton:(UIButton*)button
{
    !self.chooseCountMsgBlock ? : self.chooseCountMsgBlock (self.defaulCount);
    [self hiddenBottomView];
}

-(void)showBottomView {
    self.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, kScreenHeight-navigationViewHeight-pickViewViewHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight);
        self.backgroundColor = windowColor;
    } completion:^(BOOL finished) {
        
    }];
    
}
-(void)hiddenBottomView {
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, navigationViewHeight+pickViewViewHeight);
        self.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lable=[[UILabel alloc]init];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.numberOfLines = 2;
    lable.font=[UIFont systemFontOfSize:14.0f];
    lable.text = [self.dataArray objectAtIndex:row];
    return lable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    //这里减五 是为了伟大的"甘肃省临夏回族自治州积石山保安族东乡族撒拉族自治县"等名字长的地方(郭长峰)
    CGFloat pickViewWidth = kScreenWidth/3-5;
    
    return pickViewWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.defaulCount = [self.dataArray objectAtIndex:row];
}

@end
