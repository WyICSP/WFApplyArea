//
//  ScanViewController.m
//  nextstep
//
//  Created by 郭永红 on 2017/6/16.
//  Copyright © 2017年 keeponrunning. All rights reserved.
//

#import "MMScanViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "MMScanBottomView.h"
#import "WFShopPublicAPI.h"
#import "WFInputWriteOffView.h"
#import "NSString+Regular.h"
#import "SKSafeObject.h"
#import "UIView+Frame.h"
#import "WFPopTool.h"
#import "WKHelp.h"
#import "YFToast.h"

//#import "ViewController.h"

#define kFlash_Y_PAD(__VALUE__) [UIScreen mainScreen].bounds.size.width / 320 * __VALUE__
static NSString *kMMScanHistoryKey = @"kMMScanHistoryKey";

@interface MMScanViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVCaptureMetadataOutputObjectsDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) MMScanView *scanRectView;

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@property (nonatomic) CGRect scanRect;

@property (nonatomic, strong) UIButton *scanTypeQrBtn; //修改扫码类型按钮
@property (nonatomic, strong) UIButton *scanTypeBarBtn; //修改扫码类型按钮

@property (nonatomic, copy) void (^scanFinish)(NSString *, NSError *);
@property (nonatomic, assign) MMScanType scanType;
@property (nonatomic, strong) MMScanBottomView *bottomView;//底部 view
/// 核销码
@property (nonatomic, strong) WFInputWriteOffView *offView;

@property (nonatomic, strong) NSMutableArray *historyRecords; //修改扫码类型按钮

@end

@implementation MMScanViewController
{
    NSString *appName;
    BOOL delayQRAction;
    BOOL delayBarAction;
    NSBundle *scanBundle;
}

- (instancetype)initWithQrType:(MMScanType)type onFinish:(void (^)(NSString *result, NSError *error))finish {
    self = [super init];
    if (self) {
        self.scanType = type;
        self.scanFinish = finish;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViewConfiguration];
    [self initScanDevide];
    [self drawTitle];
    [self drawScanView];
    [self initScanType];
    [self createBackButton];
    [self.view addSubview:self.bottomView];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)initViewConfiguration {
    self.title = @"扫一扫";
    delayQRAction = NO;
    delayBarAction = NO;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (appName == nil || appName.length == 0) {
        appName = @"该App";
    }
    
//    scanBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"resource" ofType: @"bundle"]];
}

- (void)initScanDevide {
    if ([self isAvailableCamera]) {
        //初始化摄像设备
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        //初始化摄像输入流
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
        //初始化摄像输出流
        self.output = [[AVCaptureMetadataOutput alloc] init];
        //设置输出代理，在主线程里刷新
        [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        
        //初始化链接对象
        self.session = [[AVCaptureSession alloc] init];
        //设置采集质量
        [self.session setSessionPreset:AVCaptureSessionPresetInputPriority];
        //将输入输出流对象添加到链接对象
        if ([self.session canAddInput:self.input]) [self.session addInput:self.input];
        if ([self.session canAddOutput:self.output]) [self.session addOutput:self.output];
        
        //设置扫码支持的编码格式【默认二维码 和条形码一起】
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        //设置扫描聚焦区域
        self.output.rectOfInterest = _scanRect;//全屏扫描;
        
        self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = [UIScreen mainScreen].bounds;
        [self.view.layer insertSublayer:self.preview atIndex:0];
    }
}

- (void)initScanType {
    if (self.scanType == MMScanTypeAll) {
        _scanRect = CGRectFromString([self scanRectWithScale:1][0]);
        self.output.rectOfInterest = _scanRect;
    } else if (self.scanType == MMScanTypeQrCode) {
//        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
//                                            AVMetadataObjectTypeEAN8Code,
//                                            AVMetadataObjectTypeCode128Code];
        self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
        self.title = @"二维码";
        _scanRect = CGRectFromString([self scanRectWithScale:1][0]);
        self.output.rectOfInterest = _scanRect;//全屏扫描_scanRect
        _tipTitle.text = @"放入框内, 自动扫描";
        
        _tipTitle.center = CGPointMake(self.view.center.x, self.view.center.y + CGSizeFromString([self scanRectWithScale:1][1]).height/2 + 25);
        
    } else if (self.scanType == MMScanTypeBarCode) {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        self.title = @"条码";
        
        _scanRect = CGRectFromString([self scanRectWithScale:3][0]);
        self.output.rectOfInterest = _scanRect;
        [self.scanRectView setScanType: MMScanTypeBarCode];
        _tipTitle.text = @"放入框内,自动扫描";
        
        _tipTitle.center = CGPointMake(self.view.center.x, self.view.center.y + CGSizeFromString([self scanRectWithScale:3][1]).height/2 + 25);
        [_flashBtn setCenter:CGPointMake(self.view.center.x, CGRectGetMaxY(self.view.frame)- kFlash_Y_PAD(120))];
    }
    [self.view bringSubviewToFront:_tipTitle];
    [self.view bringSubviewToFront:_flashBtn];
}
    


- (NSArray *)scanRectWithScale:(NSInteger)scale {
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    CGFloat Left = 60 / scale;
    CGSize scanSize = CGSizeMake(self.view.frame.size.width - Left * 2, (self.view.frame.size.width - Left * 2) / scale);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    return @[NSStringFromCGRect(scanRect), NSStringFromCGSize(scanSize)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    //开始捕获
    if (self.session) [self.session startRunning];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //开始捕获
    if (self.session) [self.session stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( (metadataObjects.count==0) )
    {
        [self showError:@"图片中未识别到二维码"];
        return;
    }
    
    if (metadataObjects.count>0) {
        [self.session stopRunning];
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //判断是否包含了二维码 或者一维码数据
        if (![metadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            [self.session startRunning];
        }else {
            NSString *url = [NSString stringWithFormat:@"%@",metadataObject.stringValue];
            [self renderUrlStr:url];
        }
    }
}


/**
 扫描成功

 @param url 扫描成功
 */
- (void)renderUrlStr:(NSString *)url {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"" forKey:@"memberMobile"];
    [params safeSetObject:url forKey:@"orderCode"];
    [params safeSetObject:@"0" forKey:@"type"];
    //返回数据
//    [[WFShopPublicAPI shareInstance] scanQRCodeWithParams:params];
    !self.scanInfoBlock ? : self.scanInfoBlock(params);
    
//    if (self.jumpScanType == WFJumpScanByApp) {
//        //如果是 APP 调起的扫描
//        [self getInputBarCodeWithShellId:url];
//    }else {
//        //如果是 H5 调起的扫描
//        !self.scanFinish ? : self.scanFinish(url,nil);
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

/**
 根据扫描的获取shellId来获取区域数据

 @param shellId 桩口号
 */
- (void)getInputBarCodeWithShellId:(NSString *)shellId {
    NSString *shellIdStr = @"";
    if ([shellId containsString:@"http://"]) {
        shellIdStr = [[shellId componentsSeparatedByString:@"="] lastObject];
    }else {
        shellIdStr = shellId;
    }
    
//    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params safeSetObject:shellId forKey:@"shellId"];
//    @weakify(self)
//    [WFHomeDataTool getInputBarCodeWithParams:params resultBlock:^(WFScanCodeModel * _Nonnull models) {
//        @strongify(self)
//        [self requestSuccessWithData:models shellId:shellIdStr];
//    } failureBlock:^{
//        @strongify(self)
//        [self failureBack];
//    }];
}

//- (void)requestSuccessWithData:(WFScanCodeModel *)models shellId:(NSString *)shellId {
//
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    [dict safeSetObject:shellId forKey:@"shellId"];
//    [dict safeSetObject:models.groupId.name forKey:@"name"];
//    [dict safeSetObject:models.groupId.address forKey:@"address"];
//    [dict safeSetObject:models.code forKey:@"code"];
//    [dict safeSetObject:models.groupId.Id forKey:@"Id"];
//    [dict safeSetObject:@(models.platformType) forKey:@"platformType"];
//
//    [YFNotificationCenter postNotificationName:@"InputBarCodeKeys" object:nil userInfo:dict];
//    [self goBack];
//}
//
//- (void)failureBack {
//    [YFToast showMessage:@"充电桩未找到"];
//    [self.navigationController popViewControllerAnimated:YES];
//}

//绘制扫描区域
- (void)drawScanView {
    _scanRectView = [[MMScanView alloc] initWithFrame:self.view.frame style:@""];
    [_scanRectView setScanType:self.scanType];
    [self.view addSubview:_scanRectView];
    
}

- (void)drawTitle
{
    if (!_tipTitle)
    {
        self.tipTitle = [[UILabel alloc]init];
        _tipTitle.bounds = CGRectMake(0, 0, 300, 50);
        _tipTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, self.view.center.y + self.view.frame.size.width/2 - 35);
        _tipTitle.font = [UIFont systemFontOfSize:13];
        _tipTitle.textAlignment = NSTextAlignmentCenter;
        _tipTitle.numberOfLines = 0;
        _tipTitle.text = @"将取景框对准二维码,即可自动扫描";
        _tipTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_tipTitle];
    }
    _tipTitle.layer.zPosition = 1;
    [self.view bringSubviewToFront:_tipTitle];
}

- (void)createBackButton {
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(18, ISIPHONEX ? 31+XHEIGHT : 31, 30, 30)];
    NSString *path = [NSString getImagePathWithCurrentBundler:[NSBundle bundleForClass:[self class]] PhotoName:@"disapper" bundlerName:@"WFShopMall.bundle"];
    [back setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)back {
    [self goBack];
}

/// 处理核销码按钮事件
/// @param tag 100 取消 200 确定
- (void)handleBtnComplateWithTag:(NSInteger)tag
                           input:(NSDictionary *)input {
    
    [self.session startRunning];
    
    [self.offView removeFromSuperview];
    self.offView = nil;
    //移除背景透明 View
    UIView * updateview  = [self.view viewWithTag:123456];
    [updateview removeFromSuperview];
    updateview = nil;
    
    if (tag == 200) {
       //数据合格
//        [[WFShopPublicAPI shareInstance] scanQRCodeWithParams:input];
        !self.scanInfoBlock ? : self.scanInfoBlock(input);
    }
    
}


- (MMScanBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView  = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"MMScanBottomView" owner:nil options:nil] firstObject];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _bottomView.titleLbl.text = @"输入核销码";
        CGFloat height = ISIPHONEX ? 90 + 50 : 90;
        WS(weakSelf)
        _bottomView.clickBtnBlock = ^(NSInteger tag, UIButton * _Nonnull btn) {
            [weakSelf openCtrlWithLampByTag:tag button:btn];
        };
        _bottomView.frame = CGRectMake(0, ScreenHeight-height, ScreenWidth, height);
    }
    return _bottomView;
}

/// 输入核销码
- (WFInputWriteOffView *)offView {
    if (!_offView) {
        _offView = [[[NSBundle bundleForClass:[self class]] loadNibNamed:@"WFInputWriteOffView" owner:nil options:nil] firstObject];
        @weakify(self)
        _offView.btnClickBlock = ^(NSInteger tag,NSDictionary *inputInfo) {
            @strongify(self)
            [self handleBtnComplateWithTag:tag input:inputInfo];
        };
    }
    return _offView;
}


/**
 打开页面和手电筒

 @param tag 10 打开页面 20 打开手电筒
 @param btn 手电筒的对象按钮
 */
- (void)openCtrlWithLampByTag:(NSInteger)tag button:(UIButton *)btn {
    if (tag == 10) {
        //开发手电筒的按钮设置为NO
        if (self.bottomView.openFlash.selected)
        self.bottomView.openFlash.selected = NO;
        
        [self.session stopRunning];
        
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        
        UIView *mainView = [[UIView alloc] initWithFrame:keyWindow.bounds];
        mainView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
        mainView.tag = 123456;
        [self.view addSubview:mainView];
        
        CGFloat halfScreenWidth = [[UIScreen mainScreen] bounds].size.width * 0.5;
        CGFloat halfScreenHeight = [[UIScreen mainScreen] bounds].size.height * 0.5;
        // 屏幕中心
        CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
        self.offView.center = screenCenter;
        [self.view addSubview:self.offView];
        
        
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.6;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.offView.layer addAnimation:popAnimation forKey:nil];
        
    }else if (tag == 20) {
        //打开手电筒
        [self openFlash:btn];
    }
}

- (void)setNavItem:(MMScanType)type {
    
    if(type == MMScanTypeBarCode) {
        if (_historyCallBack) {
            _historyItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan_history" inBundle:scanBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(callbackHistory)];
            [self.navigationItem setRightBarButtonItem:_historyItem];
        }
    } else {
        if (_historyCallBack) {
            _photoItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoto)];
            _historyItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"scan_history" inBundle:scanBundle compatibleWithTraitCollection:nil] style:UIBarButtonItemStylePlain target:self action:@selector(callbackHistory)];
            [self.navigationItem setRightBarButtonItems:@[_photoItem, _historyItem]];
        } else {
            _photoItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:UIBarButtonItemStylePlain target:self action:@selector(openPhoto)];
            [self.navigationItem setRightBarButtonItem:_photoItem];
        }
    }
}

- (void)callbackHistory {
    if (self.historyCallBack) {
        self.historyCallBack([self.historyRecords copy]);
    }
}

- (void)initHistory {
    if (!self.historyRecords) {
        self.historyRecords = [NSMutableArray array];
    }
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kMMScanHistoryKey]) {
        [self.historyRecords addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:kMMScanHistoryKey]];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - 修改扫码类型 【二维码  || 条形码】
- (void)changeScanCodeType:(MMScanType)type {
    [self.session stopRunning];
    __weak typeof (self)weakSelf = self;
    CGSize scanSize = CGSizeFromString([self scanRectWithScale:1][1]);
    if (type == MMScanTypeBarCode) {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        _scanRect = CGRectFromString([weakSelf scanRectWithScale:3][0]);
        scanSize = CGSizeFromString([self scanRectWithScale:3][1]);
    } else {
        self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,
                                            AVMetadataObjectTypeEAN8Code,
                                            AVMetadataObjectTypeCode128Code];
        _scanRect = CGRectFromString([weakSelf scanRectWithScale:1][0]);
        scanSize = CGSizeFromString([self scanRectWithScale:1][1]);
    }
    
    
    //设置扫描聚焦区域
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.output.rectOfInterest = weakSelf.scanRect;
        [weakSelf.scanRectView setScanType: type];
        weakSelf.tipTitle.text = type == MMScanTypeQrCode ? @"将取景框对准二维码,即可自动扫描" : @"将取景框对准条码,即可自动扫描";
        [weakSelf.session startRunning];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.tipTitle.center = CGPointMake(self.view.center.x, self.view.center.y + scanSize.height/2 + 25);
        [weakSelf.flashBtn setCenter:CGPointMake(self.view.center.x, type == MMScanTypeQrCode ? (self.view.center.y + kFlash_Y_PAD(70)) : CGRectGetMaxY(self.view.frame)- kFlash_Y_PAD(120))];
    }];
    
    if ([self.bottomView.openFlash isSelected]) {
        self.bottomView.openFlash.selected = !self.bottomView.openFlash.selected;
    }
}

//打开相册
- (void)openPhoto
{
    if ([self isAvailablePhoto])
        [self openPhotoLibrary];
    else
    {
        NSString *tipMessage = [NSString stringWithFormat:@"请到手机系统的\n【设置】->【隐私】->【相册】\n对\"%@\"开启相机的访问权限",appName];
        [self showError:tipMessage andTitle:@"相册读取权限未开启"];
    }
}

- (void)openPhotoLibrary
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    picker.delegate = self;
    
    
    picker.allowsEditing = YES;
    
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    __block UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if (!image){
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    [self recognizeQrCodeImage:image onFinish:^(NSString *result) {
        [self renderUrlStr:result];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"cancel");
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 闪光灯开启与关闭
- (void)openFlash:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    AVCaptureDevice *device =  [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] && [device hasFlash])
    {
        AVCaptureTorchMode torch = self.input.device.torchMode;
        
        switch (_input.device.torchMode) {
            case AVCaptureTorchModeAuto:
                break;
            case AVCaptureTorchModeOff:
                torch = AVCaptureTorchModeOn;
                break;
            case AVCaptureTorchModeOn:
                torch = AVCaptureTorchModeOff;
                break;
            default:
                break;
        }
        
        [_input.device lockForConfiguration:nil];
        _input.device.torchMode = torch;
        [_input.device unlockForConfiguration];
    }
}

#pragma mark - 相册与相机是否可用
- (BOOL)isAvailablePhoto
{
    PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
    if ( authorStatus == PHAuthorizationStatusDenied ) {
        
        return NO;
    }
    return YES;
}
- (BOOL)isAvailableCamera {
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        /// 用户是否允许摄像头使用
        NSString * mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        /// 不允许弹出提示框
        if (authorizationStatus == AVAuthorizationStatusRestricted ||
            authorizationStatus == AVAuthorizationStatusDenied) {
            NSString *tipMessage = [NSString stringWithFormat:@"请到手机系统的\n【设置】->【隐私】->【相机】\n对\"%@\"开启相机的访问权限",appName];
            [self showError:tipMessage andTitle:@"相机权限未开启"];
            
            return NO;
        }else{
            return  YES;
        }
    } else {
        //相机硬件不可用【一般是模拟器】
        return NO;
    }
}

#pragma mark - Error handle
- (void)showError:(NSString*)str {
    [self showError:str andTitle:@"提示"];
}

- (void)showError:(NSString*)str andTitle:(NSString *)title
{
    [self.session stopRunning];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *action = ({
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.session startRunning];
        }];
        action;
    });
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

#pragma mark - 识别二维码
+ (void)recognizeQrCodeImage:(UIImage *)image onFinish:(void (^)(NSString *result))finish {
    [[[MMScanViewController alloc] init] recognizeQrCodeImage:image onFinish:finish];
}

- (void)recognizeQrCodeImage:(UIImage *)image onFinish:(void (^)(NSString *result))finish {
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0 ) {
        
        [self showError:@"只支持iOS8.0以上系统"];
        return;
    }
    
    //系统自带识别方法
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >=1)
    {
        CIQRCodeFeature *feature = [features objectAtIndex:0];
        NSString *scanResult = feature.messageString;
        [_historyRecords insertObject:scanResult atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:_historyRecords forKey:kMMScanHistoryKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (finish) {
            finish(scanResult);
        }
    } else {
        [self showError:@"图片中未识别到二维码"];
    }
}
#pragma mark - 创建二维码/条形码
+ (UIImage*)createQRImageWithString:(NSString*)content QRSize:(CGSize)size
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *qrImage = qrFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//引用自:http://www.jianshu.com/p/e8f7a257b612
//引用自:https://github.com/MxABC/LBXScan
+ (UIImage* )createQRImageWithString:(NSString*)content QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",qrFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

//TODO: 绘制条形码
+ (UIImage *)createBarCodeImageWithString:(NSString *)content barSize:(CGSize)size
{
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *qrImage = filter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}


+ (UIImage* )createBarCodeImageWithString:(NSString*)content QRSize:(CGSize)size QRColor:(UIColor*)qrColor bkColor:(UIColor*)bkColor
{
    NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
    //生成
    CIFilter *barFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    [barFilter setValue:stringData forKey:@"inputMessage"];
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                       keysAndValues:
                             @"inputImage",barFilter.outputImage,
                             @"inputColor0",[CIColor colorWithCGColor:qrColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:bkColor.CGColor],
                             nil];
    
    CIImage *qrImage = colorFilter.outputImage;
    //绘制
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

#pragma mark - 延时操作器
- (void)performTaskWithTimeInterval:(NSTimeInterval)timeInterval action:(void (^)(void))action
{
    double delayInSeconds = timeInterval;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        action();
    });
}

- (void)clearAllRecords {
    [_historyRecords removeAllObjects];
    
    [[NSUserDefaults standardUserDefaults] setObject:_historyRecords forKey:kMMScanHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearRecordIndex: (NSUInteger)index {
    if (_historyRecords.count <= index) return
    [_historyRecords removeObjectAtIndex:index];
    
    [[NSUserDefaults standardUserDefaults] setObject:_historyRecords forKey:kMMScanHistoryKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
