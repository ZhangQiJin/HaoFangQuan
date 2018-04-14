//
//  WSConfigPhoneViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSConfigPhoneViewController.h"
#import "WSRsetTiXianPasswordViewController.h"
#import "WSSetTiXianPassWordViewController.h"
#import "JKCountDownButton.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSConfigPhoneViewController ()<UITextFieldDelegate>
{
    JKCountDownButton *_countDownCode;
    NSUInteger _textFieldState;
}
@property(strong,nonatomic)UIView *coverView;
@property (weak, nonatomic) IBOutlet UIView *configBackView;
@property(copy,nonatomic)NSString *receivedCode;
- (IBAction)jumpToResetTiXianPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *configTextField;
@end

@implementation WSConfigPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
}
#define textFieldSecurity 0
#define textFieldUnsecurity 1
-(void)setUpAppearance{
//    self.huoQuYanZhengMaBackView.layer.borderWidth = 0.5;
//    self.huoQuYanZhengMaBackView.layer.borderColor = [[UIColor redColor]CGColor];
//    self.huoQuYanZhengMaBackView.layer.cornerRadius = 10;
//    self.huoQuYanZhengMaBackView.layer.masksToBounds = YES;
//    self.tiShiView.layer.cornerRadius = 10.0f;
    _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _countDownCode.frame = CGRectMake(190,10, 108, 32);
    [_countDownCode setTitle:@"获取验证码(60)" forState:UIControlStateNormal];
    //_countDownCode.backgroundColor = [UIColor blueColor];
    _countDownCode.layer.cornerRadius = 5.0f;
    _countDownCode.layer.masksToBounds = YES;
    _countDownCode.layer.borderWidth = 0.5f;
    _countDownCode.layer.borderColor = [[UIColor redColor]CGColor];
    [_countDownCode setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _countDownCode.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.configBackView addSubview:_countDownCode];
    //__block WSUserRegistViewController* bObject = self;
    __weak WSConfigPhoneViewController *weakSelf = self;
    [_countDownCode addToucheHandler:^(JKCountDownButton*sender, NSInteger tag) {
        sender.enabled = NO;
        [sender startWithSecond:60];
        //发送请求
        [weakSelf receiveConfigCode];
        [sender didChange:^NSString *(JKCountDownButton *countDownButton,int second) {
            NSString *title = [NSString stringWithFormat:@"获取验证码(%d)",second];
            return title;
        }];
        [sender didFinished:^NSString *(JKCountDownButton *countDownButton, int second) {
            countDownButton.enabled = YES;
            return @"点击重新获取";
        }];
    }];
    _textFieldState = textFieldSecurity;
}
//点击获取验证码
-(void)receiveConfigCode{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *ipString = ReceiveConfigMessage;
    NSString *loginPhoneStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginPhone"];
    NSDictionary *para = @{@"phoneNum":loginPhoneStr};
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //NSLog(@"msg%@",statusDict[@"msg"]);
        NSLog(@"code%@",statusDict[@"verifyCode"]);
        self.receivedCode =[NSString stringWithFormat:@"%@",statusDict[@"verifyCode"]]; //statusDict[@"verifyCode"];
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"验证码获取失败,请重试"];
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (![textField.text isEqualToString:self.receivedCode]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"验证码输入错误,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
//        textField.text = @"";
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.subJectWords != nil) {
        self.subJectLabel.text = self.subJectWords;
        self.alertLabel.text = self.alertWords;
    }
    NSString *loginPhoneStr = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginPhone"];
    NSString *preStr = [loginPhoneStr substringToIndex:3];
    NSString *surStr = [loginPhoneStr substringFromIndex:7];
    self.alertLabel.text =[NSString stringWithFormat:@"绑定银行卡需要短信确认，验证码已发送至手机%@****%@，请按提示操作",preStr,surStr];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)canNotReceiveCode:(id)sender {
    self.coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    self.coverView.backgroundColor = [UIColor lightGrayColor];
    self.coverView.alpha = 0.5;
    [self.view addSubview:self.coverView];
    self.tiShiView.hidden = NO;
    [self.view bringSubviewToFront:self.tiShiView];
}

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)hideAlertView:(id)sender {
    self.tiShiView.hidden = YES;
    [self.coverView removeFromSuperview];
}
- (IBAction)jumpToResetTiXianPassword:(id)sender {
    if ([self.configTextField.text isEqualToString:self.receivedCode]) {
//        WSRsetTiXianPasswordViewController *resetTiXianPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"resetTiXianPasswordVC"];
//        [self.navigationController showViewController:resetTiXianPasswordVC sender:nil];
        WSSetTiXianPassWordViewController *setTiXianPasswordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"setTiXianPasswordVC"];
        [self.navigationController showViewController:setTiXianPasswordVC sender:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"验证码输入错误,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        self.configTextField.text = @"";
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
