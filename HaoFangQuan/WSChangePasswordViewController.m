//
//  WSChangePasswordViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.


#import "WSChangePasswordViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Hash.h"
@interface WSChangePasswordViewController ()<UITextFieldDelegate>
{
    NSUInteger _textFieldState;
}
@end
#define textFieldSecurity 0
#define textFieldUnsecurity 1
@implementation WSChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textFieldState = textFieldSecurity;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.changeTextField) {
        self.changedClearButton.hidden = NO;
    }else if (textField == self.confirmTextField){
        self.confirmClearButton.hidden = NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.changeTextField) {
        self.changedClearButton.hidden= YES;
        if (!(textField.text.length >= 6)) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"密码不能少于6位，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            textField.text = @"";
        }
    }else if (textField == self.confirmTextField){
        self.confirmClearButton.hidden = YES;
        if (![self.confirmTextField.text isEqualToString:self.changeTextField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"两次输入密码不一致，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            textField.text = @"";
        }
    }else{
        //判断原密码是否正确
        NSString *oldPassWord = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginPassword"];
        if (![textField.text isEqualToString:oldPassWord]) {
            self.originTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"原密码输入错误，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        }
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

- (IBAction)turnBakc:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitChangedPassword:(id)sender {
    if ((self.changeTextField.text.length>0)&&(self.originTextField.text.length>0)&&(self.confirmTextField.text.length>0)) {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    //NSDictionary *para = @{@"tokenId":userLoginToken,@"password":self.originTextField.text,@"newPassword":self.changeTextField.text};
        NSString *oldStr = [self.originTextField.text md5String];
        NSString *newStr = [self.changeTextField.text md5String];
    NSDictionary *para = @{@"password":oldStr,@"newPassword":newStr,@"tokenId":userLoginToken};
    NSString *ipString = changeLoginPassWord;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        NSLog(@"ret=%@",result);
        NSLog(@"修改密码msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setObject:self.changeTextField.text forKey:@"loginPassword"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"信息填写不完善，请补充后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (IBAction)swapeTextFieldDisplay:(id)sender {
    if (_textFieldState == textFieldSecurity) {
        self.originTextField.secureTextEntry = NO;
        _textFieldState = textFieldUnsecurity;
    }else{
        self.originTextField.secureTextEntry = YES;
        _textFieldState = textFieldSecurity;
    }
}

- (IBAction)clearChangedTextField:(id)sender {
    self.changeTextField.text = @"";
}
- (IBAction)clearConfrimTextField:(id)sender {
    self.confirmTextField.text = @"";
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
