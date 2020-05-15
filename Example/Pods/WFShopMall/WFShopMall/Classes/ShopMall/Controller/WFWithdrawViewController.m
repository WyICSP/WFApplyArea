//
//  WFWithdrawViewController.m
//  AFNetworking
//
//  Created by YZC on 2019/11/4.
//
#import "WFBindWithdrawViewController.h"
#import "UITextField+RYNumberKeyboard.h"
#import "WFWithdrawViewController.h"
#import "WFShopMallIncomeViewController.h"
#import "WFWithdrawModel.h"
#import "WFShopDataTool.h"
#import "SVProgressHUD.h"
#import "SKSafeObject.h"
#import "UserData.h"
#import "WKHelp.h"
#import "WKSetting.h"



@interface WFWithdrawViewController ()<UITextFieldDelegate>


/**账户名*/
@property (weak, nonatomic) IBOutlet UILabel *accountName;
/**账户手机号*/
@property (weak, nonatomic) IBOutlet UILabel *accountPhone;
/**textfield*/
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
/**可用金额*/
@property (weak, nonatomic) IBOutlet UILabel *usableMoney;
/**没有绑定 点击绑定信息*/
@property (weak, nonatomic) IBOutlet UIButton *nextBut;
/**提示but*/
@property (weak, nonatomic) IBOutlet UIButton *promptBut;
/**提现but*/
@property (weak, nonatomic) IBOutlet UIButton *submitBut;
/**数据源model*/
@property (nonatomic, strong) WFWithdrawModel *model;
/**绑定q详情的数据*/
@property (nonatomic, strong) WFWithdrawdChannelDetailModel *channeModel;

@end



@implementation WFWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];

    
}

/**初始化ui 数据*/
- (void)setUI{
    self.title = @"提现";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.submitBut.layer.cornerRadius = self.submitBut.height/2;
    self.submitBut.enabled = NO;
    self.submitBut.alpha = 0.6f;
    self.moneyTextField.delegate = self;
    [self.moneyTextField setMoneyKeyboard];
    // 设置 placeholder
    NSString *holderText = @"请输入提现金额";
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:holderText];
    [placeholder addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xCCCCCC) range:NSMakeRange(0, holderText.length)];
    [placeholder addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, holderText.length)];
    self.moneyTextField.attributedPlaceholder = placeholder;
    
    //通过 KVC 监听 moneyTF 的 text
    [self.moneyTextField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:NULL];
    

    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self getData];
    
  
    
}


/**获取数据*/
- (void)getData{
   
    [SVProgressHUD showWithStatus:@"加载中..."];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:USER_UUID forKey:@"userId"];
    
    @weakify(self)
    [WFShopDataTool getWithdrawDataWithParams:params resultBlock:^(WFWithdrawModel  *model) {
        @strongify(self)
        [SVProgressHUD dismiss];
        self.model = model;
        [self setUIWithData:self.model];
        
    } failBlock:^{
        [SVProgressHUD dismiss];
        
        
    }];
    
}

/**根据数据 设置ui*/
- (void)setUIWithData:(WFWithdrawModel *)model{
    
    self.channeModel = [self.model.channelList firstObject];
    
    /**余额 要大于等于最小提现金额*/
      if (([self.model.money integerValue] >= [self.model.minTransfer integerValue]) && self.channeModel.binding) {
          self.submitBut.enabled = YES;
          self.submitBut.alpha = 1.0f;
      }else{
          self.submitBut.enabled = NO;
          self.submitBut.alpha = 0.6f;
      }
    //最小金额提示
    [self.promptBut setTitle:model.settleTips forState:UIControlStateNormal];
    self.usableMoney.text = [NSString stringWithFormat:@"可提现余额%.2f元",[self.model.money doubleValue]/100];
    
    
    
    self.nextBut.hidden = self.channeModel.binding;
    self.accountName.text = self.channeModel.binding ? self.channeModel.userName :@"支付宝";
    self.accountPhone.text = self.channeModel.binding ? self.channeModel.accountName :@"还没有添加支付宝账户，请点击添加";
    
    
    
}

/**提示button事件*/
- (IBAction)promptButtonAction:(id)sender {
    
//    NSString *tempMoney = [self.moneyTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
     NSString *tempMoney = [self conversionMoney: self.moneyTextField.text];
    
    
    if ([self.model.money integerValue] < [self.model.minTransfer integerValue] || ([tempMoney integerValue] > [self.model.money integerValue] ) || !self.channeModel.binding) {
        // 没有事件
        return;
    }else{
        /**全部提现*/
        self.moneyTextField.text = [NSString stringWithFormat:@"%.2f",([self.model.money doubleValue]/100)];

    }
    
    
    
    
}




/**提交事件*/
- (IBAction)submitButtonAction:(id)sender {
    
//    NSString *tempMoney = [self.moneyTextField.text stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *tempMoney = [self conversionMoney: self.moneyTextField.text];
    if([self.model.money integerValue] < [self.model.minTransfer integerValue] || ([tempMoney integerValue] > [self.model.money integerValue ])||!self.channeModel.binding || [tempMoney integerValue] <  [self.model.minTransfer integerValue]){

        return;
    }else{
        
        [SVProgressHUD showWithStatus:@"加载中..."];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params safeSetObject:@"0" forKey:@"type"];
        [params safeSetObject:tempMoney forKey:@"money"];
        
        // 提交事件
        [WFShopDataTool WithdrawWithParams:params resultBlock:^(NSDictionary * _Nonnull detailID) {
            [SVProgressHUD dismiss];
            // 提现成功做一个标记  用户点击a返回按钮返回到根视图
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"withdeawToRoot"];
            self.moneyTextField.text = @"";
            WFShopMallIncomeViewController *incomeVC = [[WFShopMallIncomeViewController alloc]init];
            incomeVC.urlString = [NSString stringWithFormat:@"%@yzc-app-partner/#/service/cashDetail?id=%@",H5_SHOP_URL,detailID[@"detailId"]];
            [self.navigationController pushViewController:incomeVC animated:YES];
            
            
//            DLog(detailID);
            
        } failBlock:^{
            [SVProgressHUD dismiss];
        }];




    }
    
}


/**绑定账号事件*/
- (IBAction)bindingAccountAction:(id)sender {
    
    WFBindWithdrawViewController *bindWithdrawVC = [[WFBindWithdrawViewController alloc] initWithNibName:@"WFBindWithdrawViewController" bundle:[NSBundle bundleForClass:[self class]]];
    bindWithdrawVC.userPhone  = self.model.mobile;
    bindWithdrawVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:bindWithdrawVC animated:NO];
     
}




/**kvo 方法*/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"text"] ) {
        
        //监听输入框
        UITextField *textField = (UITextField *)object;
        //小数点后只能输入两位小数
        NSString *textStr = textField.text;
        
        if ([textStr containsString:@"."] ) {
            NSRange strRange = [textStr rangeOfString:@"."];
            if (textStr.length - strRange.location > 3) {
                textStr = [textStr substringToIndex:strRange.location +3];
                textField.text = textStr;
            }
        }
        
        [self textFieldDidChange:textField];
    }
}

/***/
- (void)textFieldDidChange:(UITextField *)textField{
    
    
//    NSString *tempMoney = self.moneyTextField.text;
    
    NSString *tempMoney = [self conversionMoney: self.moneyTextField.text];
    
    
    
    if ([tempMoney integerValue] > [self.model.money integerValue]) {
        // 输入金额大于可提现金额
        [self.promptBut setTitle:@"金额已超过可提现余额" forState:UIControlStateNormal];
        self.usableMoney.text = @"";
    }else{
        
        if([self.model.money integerValue] > [self.model.minTransfer integerValue]){
            // 输入金额小于可提现金额
            [self.promptBut setTitle:@"全部提现" forState:UIControlStateNormal];
        }else{
            [self.promptBut setTitle:self.model.settleTips forState:UIControlStateNormal];
        }
         self.usableMoney.text = [NSString stringWithFormat:@"可提现余额%.2f元",[self.model.money doubleValue]/100];
    }

}

/**UITextFieldDelegate*/
- (BOOL)textFieldShouldClear:(UITextField *)textField{
 
//返回一个BOOL值指明是否允许根据用户请求清除内容
    [self setUIWithData:self.model];
     return YES;
}


/**金额转换  把以元为单位 转换为以分为单位*/
-(NSString *)conversionMoney:(NSString *)moneyStr {
    
    NSRange strRange = [moneyStr rangeOfString:@"."];
    
    if (strRange.length == 0) {

        moneyStr = [moneyStr stringByAppendingFormat:@".00"];
    }else if (strRange.length ==1){
        switch (moneyStr.length - strRange.location) {
            case 1:
              moneyStr = [moneyStr stringByAppendingFormat:@"00"];
                break;
            case 2:
                moneyStr = [moneyStr stringByAppendingFormat:@"0"];
                  break;
            default:
                break;
        }
    }

    return [moneyStr stringByReplacingOccurrencesOfString:@"." withString:@""];
    
}





#pragma mark - set get




/**dealloc*/
- (void)dealloc {
    [self.moneyTextField removeObserver:self forKeyPath:@"text"];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
