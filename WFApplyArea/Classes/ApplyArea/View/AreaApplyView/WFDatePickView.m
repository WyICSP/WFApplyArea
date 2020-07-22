//
//  WFDatePickView.m
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

#import "WFDatePickView.h"

@interface WFDatePickView()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIView *bottomView;//包括导航视图和地址选择视图
@property (nonatomic, strong) UIPickerView *pickView;//地址选择视图
@property (nonatomic, strong) UIView *navigationView;//上面的导航视图
@property (nonatomic, strong) NSString *year,*month,*day;
@property (nonatomic, strong) NSArray *yearArray;//年
@property (nonatomic, strong) NSArray *monthArray;//月
@property (nonatomic, strong) NSArray *dayArray;//日
@end

@implementation WFDatePickView

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
    
    //获取年的数据
    self.yearArray = [self getYearData];
    //获取月的数据
    self.monthArray = [self getMonthDataWithIndex:0];
    //获取对应月的天数
    NSString *year = [NSString stringWithFormat:@"%@:%@",[[self getYearData] firstObject],[[self getMonthDataWithIndex:0] objectAtIndex:0]];
    self.dayArray = [self getDataCountWithDateString:year];
    
    //获取默认数据
    self.year = [self.yearArray firstObject];
    self.month = [self.monthArray firstObject];
    self.day = [self.dayArray firstObject];
    
    
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
    [sureBtn setTitleColor:[UIColor colorWithRed:255.0/255.0 green:189.0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
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
    NSString *date = [NSString stringWithFormat:@"%@-%@-%@",self.year,self.month,self.day];
    !self.chooseDateMsgString ? : self.chooseDateMsgString (date);
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
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearArray.count;
    } else if (component == 1) {
        return self.monthArray.count;
    } else {
        return self.dayArray.count;
    }
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *lable=[[UILabel alloc]init];
    lable.textAlignment=NSTextAlignmentCenter;
    lable.numberOfLines = 2;
    lable.font=[UIFont systemFontOfSize:14.0f];
    if (component == 0) {
        lable.text = [self.yearArray objectAtIndex:row];
    } else if (component == 1) {
        lable.text = [NSString stringWithFormat:@"%ld",[[self.monthArray objectAtIndex:row] integerValue]];
    } else {
        lable.text = [self.dayArray objectAtIndex:row];
    }
    return lable;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    //这里减五 是为了伟大的"甘肃省临夏回族自治州积石山保安族东乡族撒拉族自治县"等名字长的地方
    CGFloat pickViewWidth = kScreenWidth/3-5;
    
    return pickViewWidth;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.year = [self.yearArray objectAtIndex:row];
        //获取月的数据
        self.monthArray = [self getMonthDataWithIndex:row];
        //获取每个月的天数
        NSString *year = [NSString stringWithFormat:@"%@:%@",[[self getYearData] objectAtIndex:row],[[self getMonthDataWithIndex:row] objectAtIndex:0]];
        self.dayArray = [self getDataCountWithDateString:year];
        
        self.month = [NSString stringWithFormat:@"%ld",[[self.monthArray firstObject] integerValue]];
        self.day = [NSString stringWithFormat:@"%ld",[[self.dayArray firstObject] integerValue]];
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else if (component == 1) {
        //获取每个月的天数
        self.month = [self.monthArray objectAtIndex:row];
        NSString *year = [NSString stringWithFormat:@"%@:%@",self.year,self.month];
        self.dayArray = [self getDataCountWithDateString:year];
        
        self.day = [NSString stringWithFormat:@"%ld",[[self.dayArray firstObject] integerValue]];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }else {
        self.day = [self.dayArray objectAtIndex:row];
    }
}

#pragma mark 本地数据
- (NSArray *)getYearData {
    //获取当前年份
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    int newYear = strDate.intValue;
    //将年份加 5 年
    NSMutableArray *yearArray = [NSMutableArray new];
    for (int i = 0 ; i <= 5; i ++) {
        [yearArray addObject:[NSString stringWithFormat:@"%d",newYear+i]];
    }
    return yearArray;
}


- (NSArray *)getMonthDataWithIndex:(NSInteger)index {
    //获取当前月份
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *months = [strDate componentsSeparatedByString:@":"];
    
    int newMonth = [months.lastObject intValue];
    NSMutableArray *monthArray = [NSMutableArray new];
    
    if ([[[self getYearData] objectAtIndex:index] isEqualToString:months.firstObject]) {
        //当年
        for (int i = 0 ; i < (12-newMonth+1); i ++) {
            if (newMonth + i < 10) {
                [monthArray addObject:[NSString stringWithFormat:@"0%d",newMonth +i]];
            }else {
                [monthArray addObject:[NSString stringWithFormat:@"%d",newMonth +i]];
            }
        }
    }else {
        for (int i = 0 ; i < 12; i ++) {
            if (i < 10) {
                [monthArray addObject:[NSString stringWithFormat:@"0%d",i+1]];
            }else {
                [monthArray addObject:[NSString stringWithFormat:@"%d",i+1]];
            }
            
        }
    }
    return monthArray;
}

/**
 获取天数
 */
- (NSArray *)getDataCountWithDateString:(NSString *)dateString {
    
    //获取当前月份
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy:MM"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    //当前日
    NSString *currentDayStr = @"";
    BOOL isCurrentMonth = NO;
    if ([strDate isEqualToString:dateString]) {
        isCurrentMonth = YES;
        //获取当前是多少号
        NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setDateFormat:@"dd"];
        currentDayStr = [dayFormatter stringFromDate:[NSDate date]];
    }
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy:MM"];
    NSDate *date = [dateFormat dateFromString:dateString];
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    // dayCountOfThisMonth就是date月份的天数
    NSInteger dayCountOfThisMonth = daysInLastMonth.length;
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    
    if (isCurrentMonth) {
        //如果是当月
        for (int i = 0; i < dayCountOfThisMonth - currentDayStr.intValue + 1; i++) {
            [dayArray addObject:[NSString stringWithFormat:@"%d",currentDayStr.intValue + i]];
        }
    }else {
        for (int i = 0; i < dayCountOfThisMonth; i++) {
            [dayArray addObject:[NSString stringWithFormat:@"%d",i+1]];
        }
    }
    
    return dayArray;
}


@end
