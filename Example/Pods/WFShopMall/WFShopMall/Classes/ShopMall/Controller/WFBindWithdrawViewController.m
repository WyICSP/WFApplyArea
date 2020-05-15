//
//  WFBindWithdrawViewController.m
//  AFNetworking
//
//  Created by YZC on 2019/11/4.
//

#import "WFBindWithdrawViewController.h"
#import "WFShopDataTool.h"
#import "SKSafeObject.h"
#import "YFToast.h"
#import "WKProxy.h"
#import "WKTimer.h"
#import "WKHelp.h"

@interface WFBindWithdrawViewController ()<UITextFieldDelegate>
/**用户名*/
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
/**账号*/
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;

/**验证码*/
@property (weak, nonatomic) IBOutlet UITextField *vCodeTextField;
/**发送验证码*/
@property (weak, nonatomic) IBOutlet UIButton *sendVCodeBut;
/**绑定手机号提示*/
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

/**确认提交*/
@property (weak, nonatomic) IBOutlet UIButton *submitBut;

/**定时器*/
@property (copy, nonatomic) NSString *task;
/**倒计时*/
@property (nonatomic, assign) NSInteger countIndex;

@end

@implementation WFBindWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
}

/**初始化 ui 数据*/
- (void)setUI{
     self.title = @"绑定支付宝";
     self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
     self.submitBut.layer.cornerRadius = self.submitBut.height/2;
     //倒计时初始值
     self.countIndex = 60;
    
    self.accountTextField.delegate = self;
    self.vCodeTextField.delegate = self;
    self.accountTextField.delegate = self;
    
    self.hintLabel.text = [NSString stringWithFormat:@"小提示：验证码将发送至您绑定的手机上(%@)",[self.userPhone stringByReplacingOccurrencesOfString:[self.userPhone substringWithRange:NSMakeRange(3,4)]withString:@"****"]];
}




/**发送验证码*/
- (IBAction)sendVCodeButtonAction:(id)sender {
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.userPhone forKey:@"phone"];
    [params setValue:@"2" forKey:@"type"];
    
    @weakify(self)
    [WFShopDataTool bindAlipaySendCodeWithParams:params resultBlock:^{
        @strongify(self)
        [YFToast showMessage:@"验证码发送成功" inView:self.view];
        self.task = [WKTimer execTask:[WKProxy proxyWithTarget:self]
                             selector:@selector(doTask)
                                start:0.0
                             interval:1.0
                              repeats:YES
                                async:NO];
    }];
    
    
}

- (void)doTask {
    self.countIndex --;
    [self.sendVCodeBut setTitle:[NSString stringWithFormat:@"%ld秒可重发",(long)self.countIndex] forState:UIControlStateNormal];
//    [self.codeBtn setTitleColor:UIColorFromRGB(0x999999) forState:0];
    self.sendVCodeBut.userInteractionEnabled = NO;
    if (self.countIndex == 0)
    {
        [self userEnableBtn];
        [WKTimer cancelTask:self.task];
        
    }
}

/**
 能用 button
 */
- (void)userEnableBtn {
    [self.sendVCodeBut setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [self.sendVCodeBut setTitleColor:NavColor forState:0];
    self.sendVCodeBut.userInteractionEnabled = YES;
    self.countIndex = 60;
}


/**提交事件*/
- (IBAction)submitButtonAction:(id)sender {
    
    // 去掉空格
    NSString *nameStr = [self.nameTextField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *accountStr = [self.accountTextField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *vCodeStr = [self.vCodeTextField.text  stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 判断
    if (nameStr.length < 1 || accountStr.length < 1 || vCodeStr.length < 1 ) {
        [YFToast showMessage:@"请输入正确的信息" inView:self.view];
        return;
    }
    // 取消键盘
    [self.view endEditing:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:accountStr forKey:@"accountNumber"];
    [params safeSetObject:nameStr forKey:@"userName"];
    [params safeSetObject:self.userPhone forKey:@"phone"];
    [params safeSetObject:vCodeStr forKey:@"code"];
    @weakify(self)
    [WFShopDataTool bindAlipayWithParams:params resultBlock:^{
        @strongify(self)
        [self bindSuccess];
    }];
    
}

/**绑定成功  返回*/
- (void)bindSuccess {
    [YFToast showMessage:@"绑定成功" inView:self.view];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

/**UITextFieldDelegate*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    
    [textField resignFirstResponder];
    return YES;
    
}
/**取消键盘*/

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    取消键盘
    [self.view endEditing:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [WKTimer cancelTask:self.task];
    [self.view endEditing:YES];
    
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
