//
//  WSTiXianMiMaViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/6.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSTiXianMiMaViewController.h"
#import "WSTiXianJiLuViewController.h"
#import "WSConfigPhoneViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "NSString+Hash.h"
#import "MBProgressHUD+MJ.h"
@interface WSTiXianMiMaViewController ()<UITextFieldDelegate>
@property(copy,nonatomic)NSString *password;
@property(strong,nonatomic)UIButton *coverButton;
@property(assign,nonatomic)int tempResult;
@property(strong,nonatomic)UITextField *passwordTF;
@property(assign,nonatomic)int didInPutLength;
@property(strong,nonatomic)NSMutableArray *addImageViewArray;
@end

@implementation WSTiXianMiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
    //NSLog(@"tiXianMoney%@",self.tiXianMoney);
}
-(void)setUpAppearance{
    self.didInPutLength = 0;
    self.addImageViewArray = [NSMutableArray array];
    self.alertBackView.layer.cornerRadius = 10;
    self.failureView.layer.cornerRadius = 10;
    self.tiXianMoneyLabel.text = [NSString stringWithFormat:@"本次提现%@元",self.tiXianMoney];
    [self refreshInputBackView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshInputBackView{
    for (int i = 0; i<5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*40, 0, 1, self.inputBackView.bounds.size.height)];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.inputBackView addSubview:label];
    }
    self.passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, 50, 30)];
    self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordTF addTarget:self action:@selector(textFieldChangedText:) forControlEvents:UIControlEventEditingChanged];
    [self.passwordTF becomeFirstResponder];
    self.passwordTF.delegate = self;
    [self.inputBackView addSubview:self.passwordTF];
}
-(void)textFieldChangedText :(UITextField*)textField{
    //NSLog(@"BFtext%@",textField.text);
    if (textField.text.length<6) {
        if (textField.text.length>self.didInPutLength) {
            self.didInPutLength ++;
            UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
            UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake((textField.text.length - 1)*40.3, 0, 39.5, 36)];
            coverimageView.image = coverImage;
            [self.inputBackView addSubview:coverimageView];
            [self.addImageViewArray addObject:coverimageView];
        }else{
            //UIImageView *imageView =(UIImageView*) [self.addImageViewArray lastObject];
            NSArray *subIamgeView = [self.inputBackView subviews];
            UIImageView *lastImageView = [subIamgeView lastObject];
            [lastImageView removeFromSuperview];
            self.didInPutLength --;
        }
    }else if(textField.text.length == 6){
        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake((textField.text.length - 1)*40.3, 0, 39.5, 36)];
        coverimageView.image = coverImage;
        [self.inputBackView addSubview:coverimageView];
        [self.addImageViewArray addObject:coverimageView];
        self.didInPutLength ++;
        //跳转提现密码确认界面
//        WSConfirmSettingTiXianMiMaViewController *confirmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmTiXianMiMaSettingVC"];
//        confirmVC.passedPassword = self.passwordTF.text;
//        [self.navigationController showViewController:confirmVC sender:nil];
        //[self startVerifyTiXianMiMa];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma textFieldDelegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.text.length<6) {
//        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
//        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake(textField.text.length*40.3, 0, 39.5, 36)];
//        coverimageView.image = coverImage;
//        [self.inputBackView addSubview:coverimageView];
//        return YES;
//    }else{
//       return NO;
//    }
//}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)tiJiaoMiMaAction:(id)sender {
    [self.passwordTF resignFirstResponder];
    self.password = self.passwordTF.text;
    //NSLog(@"%@",self.password);
    
    self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.coverButton.frame = self.view.bounds;
    self.coverButton.backgroundColor = [UIColor darkGrayColor];
    self.coverButton.alpha = 0.5f;
    [self.view addSubview:self.coverButton];
    //临时测试tempResutle（密码判断结果）
    [self startVerifyTiXianMiMa];
}
-(void)startVerifyTiXianMiMa{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSString *tiXianMiMa = [self.passwordTF.text md5String];
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pinPassword":tiXianMiMa};
    NSString *ipString = verifyTiXianMiMa;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        self.coverButton.hidden = YES;
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
//            self.alertBackView.hidden = NO;
//            [self.view bringSubviewToFront:self.alertBackView];
            [self submitTiXianInfo];
        }else{
            [self.passwordTF resignFirstResponder];
            self.failureView.hidden = NO;
            [self.view bringSubviewToFront:self.failureView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(void)submitTiXianInfo{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    //NSString *tiXianMiMa = [self.passwordTF.text md5String];
    NSDictionary *para = @{@"tokenId":userLoginToken,@"money":self.tiXianMoney,@"id":self.bankID};
    //NSLog(@"passedBankID%@",self.bankID);
    NSString *ipString = startTiXian;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"提现消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            self.alertBackView.hidden = NO;
            [self.view bringSubviewToFront:self.alertBackView];
        }else{
            //[MBProgressHUD showError:@"提现失败,请重新提交"];
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
- (IBAction)jumpToTiXianJiLuPage:(id)sender {
    WSTiXianJiLuViewController *tiXianRecordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tiXianRecordVC"];
    [self.navigationController showViewController:tiXianRecordVC sender:nil];
}

- (IBAction)jumpToWoDeQianBao:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)findBackPassword:(id)sender {
    self.failureView.hidden = YES;
    [self.coverButton removeFromSuperview];
    NSMutableArray *tempArray =(NSMutableArray *) self.inputBackView.subviews;
    for (UILabel *label in tempArray) {
        [label removeFromSuperview];
    }
    [self refreshInputBackView];
    WSConfigPhoneViewController *configVC = [self.storyboard instantiateViewControllerWithIdentifier:@"configCodeVC"];
    configVC.subJectWords = @"找回提现密码";
    //NSString *phoneNum = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginPhone"];
    //configVC.alertWords = [NSString stringWithFormat:@"找回提现密码需要短信验证，验证码发送至手机%@,请按提示操作",phoneNum];
    [self.navigationController showViewController:configVC sender:nil];
}

- (IBAction)inputAgain:(id)sender {
    self.failureView.hidden = YES;
    [self.coverButton removeFromSuperview];
    NSMutableArray *tempArray =(NSMutableArray *) self.inputBackView.subviews;
    for (UILabel *label in tempArray) {
        [label removeFromSuperview];
    }
    [self refreshInputBackView];
}
@end
