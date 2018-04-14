//
//  WSUserRegistViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/22.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSUserRegistViewController.h"
#import "JKCountDownButton.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MuseHeader.h"
#import "NSString+Hash.h"
@interface WSUserRegistViewController ()<UITextFieldDelegate>
{
    JKCountDownButton *_countDownCode;
    NSUInteger _textFieldState;
}
@property(copy,nonatomic)NSString *receivedCode;
@end

@implementation WSUserRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    [self setUpAppearance];
}
#define textFieldSecurity 0
#define textFieldUnsecurity 1
-(void)setUpAppearance{
    _countDownCode = [JKCountDownButton buttonWithType:UIButtonTypeCustom];
    _countDownCode.frame = CGRectMake(198, 3, 108, 32);
    [_countDownCode setTitle:@"获取验证码(60)" forState:UIControlStateNormal];
    //_countDownCode.backgroundColor = [UIColor blueColor];
    _countDownCode.layer.cornerRadius = 5.0f;
    _countDownCode.layer.masksToBounds = YES;
    _countDownCode.layer.borderWidth = 0.5f;
    _countDownCode.layer.borderColor = [[UIColor redColor]CGColor];
    [_countDownCode setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    _countDownCode.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.configButtonBackView addSubview:_countDownCode];
    //__block WSUserRegistViewController* bObject = self;
    __weak WSUserRegistViewController *weakSelf = self;
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
    if (self.phoneTextField.text.length>0) {
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString *ipString = ReceiveConfigMessage;
        NSDictionary *para = @{@"phoneNum":self.phoneTextField.text};
        ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
            //NSLog(@"msg%@",statusDict[@"msg"]);
            NSLog(@"code%@",statusDict[@"verifyCode"]);
            self.receivedCode =[NSString stringWithFormat:@"%@",statusDict[@"verifyCode"]]; //statusDict[@"verifyCode"];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"验证码获取失败,请重试"];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"手机号不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.configCodeTextField) {
        if (![textField.text isEqualToString:self.receivedCode]) {
            //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"验证码错误,请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            //[alert show];
            textField.text = @"";
            //[textField becomeFirstResponder];
        }
    }else if (textField == self.phoneTextField){
        if (!(textField.text.length == 11)) {
            textField.text = @"";
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"手机号填写不完整,请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
        }
        if (![self isMobileNumber:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您输入的手机号码格式有误，请确认后再次输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            textField.text = @"";
        }
    }else if (textField == self.passwordTextField){
        if (textField.text.length<6) {
            textField.text = @"";
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"密码不能少于6位，请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
        }
    }else if (textField == self.nameTextField){
//        if ((textField.text.length>6) && (textField.text.length<=0)) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"用户名输入不合法，请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        if ([self stringContainsEmoji:textField.text]) {
//            textField.text = @"";
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"用户名不能含有表情字符，请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
//        }
        if (textField.text.length<2||textField.text.length>8) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名长度只能为2-8个字符,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTextField.text = @"";
        }
        if (![self isChinesecharacter:textField.text]) {
//   UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名只能为汉字,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTextField.text = @"";
        }
    }
}
- (BOOL)isChinesecharacter:(NSString *)string{
    NSString *regex = @"[\u4e00-\u9fa5][\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: string];
}

//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == self.phoneTextField) {
//        if (textField.text.length<11) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }else{
//        return YES;
//    }
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)turnBack:(id)sender {
    [self.view endEditing:YES];
    if ([self.pushIndex isEqualToString:@"guidePage"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)changeTextFieldType:(id)sender {
    if (_textFieldState == textFieldSecurity) {
        self.passwordTextField.secureTextEntry = NO;
        _textFieldState = textFieldUnsecurity;
    }else{
        self.passwordTextField.secureTextEntry = YES;
        _textFieldState = textFieldSecurity;
    }
}

- (IBAction)completeUserRegest:(id)sender {
    if ((self.nameTextField.text.length>0)&&(self.configCodeTextField.text.length>0)&&(self.passwordTextField.text.length>0)&&(self.phoneTextField.text.length>0)) {
    [MBProgressHUD showMessage:@"正在拼命提交"];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *ipString = userRegest;
    NSString *md5Password = [self.passwordTextField.text md5String];
    NSDictionary *para = @{@"userName":self.nameTextField.text,@"phoneNum":self.phoneTextField.text,@"password":md5Password,@"invitePhoneNum":self.investTextField.text,@"verifyCode":self.receivedCode};
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //NSLog(@"code%@",statusDict[@"verifyCode"]);
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"注册成功!"];
            NSUserDefaults *defau =[NSUserDefaults standardUserDefaults];
            [defau setObject:self.phoneTextField.text forKey:@"loginPhone"];
            [defau setObject:self.passwordTextField.text forKey:@"loginPassword"];
            //[defau setObject:md5Password forKey:@"md5Password"];
            [defau synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"注册信息输入不完整，请补充完整后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[019])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
//-(BOOL)stringContainsEmoji:(NSString *)string {
//    __block BOOL returnValue = NO;
//    
//    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
//    options:NSStringEnumerationByComposedCharacterSequences
//    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
//        const unichar hs = [substring characterAtIndex:0];
//        if (0xd800 <= hs && hs <= 0xdbff) {
//            if (substring.length > 1) {
//                const unichar ls = [substring characterAtIndex:1];
//                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
//                if (0x1d000 <= uc && uc <= 0x1f77f) {
//                        returnValue = YES;
//                }
//            }
//        } else if (substring.length > 1) {
//            const unichar ls = [substring characterAtIndex:1];
//            if (ls == 0x20e3) {
//                returnValue = YES;
//            }
//        } else {
//            if (0x2100 <= hs && hs <= 0x27ff) {
//                returnValue = YES;
//            } else if (0x2B05 <= hs && hs <= 0x2b07) {
//                returnValue = YES;
//            } else if (0x2934 <= hs && hs <= 0x2935) {
//                returnValue = YES;
//            } else if (0x3297 <= hs && hs <= 0x3299) {
//                returnValue = YES;
//            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
//                returnValue = YES;
//            }
//        }
//    }];
//    return returnValue;
//}
- (IBAction)addPhoneNumber:(id)sender {
    [self.phoneTextField becomeFirstResponder];
}

- (IBAction)addConfigCode:(id)sender {
    [self.configCodeTextField becomeFirstResponder];
//    if ([self.configCodeTextField.text isEqualToString:self.receivedCode]) {
//        [self.configCodeTextField becomeFirstResponder];
//    }else{
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"请正确输入短信验证码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}

- (IBAction)setPassWord:(id)sender {
    if ([self.configCodeTextField.text isEqualToString:self.receivedCode]) {
        [self.passwordTextField becomeFirstResponder];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提醒您" message:@"请正确输入短信验证码" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        [self.configCodeTextField becomeFirstResponder];
    }
}

- (IBAction)doneRegest:(id)sender {
    [self.passwordTextField resignFirstResponder];
    if ((self.nameTextField.text.length>0)&&(self.configCodeTextField.text.length>0)&&(self.passwordTextField.text.length>0)&&(self.phoneTextField.text.length>0)) {
        [MBProgressHUD showMessage:@"正在拼命提交"];
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString *ipString = userRegest;
        NSString *md5Password = [self.passwordTextField.text md5String];
        NSDictionary *para = @{@"userName":self.nameTextField.text,@"phoneNum":self.phoneTextField.text,@"password":md5Password,@"invitePhoneNum":self.investTextField.text,@"verifyCode":self.receivedCode};
        ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
            [MBProgressHUD hideHUD];
            //NSLog(@"msg%@",statusDict[@"msg"]);
            //NSLog(@"code%@",statusDict[@"verifyCode"]);
            NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
            //NSLog(@"ret%@",result);
            if ([result isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"注册成功!"];
                NSUserDefaults *defau =[NSUserDefaults standardUserDefaults];
                [defau setObject:self.phoneTextField.text forKey:@"loginPhone"];
                [defau setObject:self.passwordTextField.text forKey:@"loginPassword"];
                //[defau setObject:md5Password forKey:@"md5Password"];
                [defau synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:statusDict[@"msg"]];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查网络连接后重试"];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"注册信息输入不完整，请补充完整后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)dongAddRecomendPerson:(id)sender {
    [self.investTextField resignFirstResponder];
    if ((self.nameTextField.text.length>0)&&(self.configCodeTextField.text.length>0)&&(self.passwordTextField.text.length>0)&&(self.phoneTextField.text.length>0)) {
        [MBProgressHUD showMessage:@"正在拼命提交"];
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString *ipString = userRegest;
        NSString *md5Password = [self.passwordTextField.text md5String];
        NSDictionary *para = @{@"userName":self.nameTextField.text,@"phoneNum":self.phoneTextField.text,@"password":md5Password,@"invitePhoneNum":self.investTextField.text,@"verifyCode":self.receivedCode};
        ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
            [MBProgressHUD hideHUD];
            //NSLog(@"msg%@",statusDict[@"msg"]);
            //NSLog(@"code%@",statusDict[@"verifyCode"]);
            NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
            //NSLog(@"ret%@",result);
            if ([result isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"注册成功!"];
                NSUserDefaults *defau =[NSUserDefaults standardUserDefaults];
                [defau setObject:self.phoneTextField.text forKey:@"loginPhone"];
                [defau setObject:self.passwordTextField.text forKey:@"loginPassword"];
                //[defau setObject:md5Password forKey:@"md5Password"];
                [defau synchronize];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [MBProgressHUD showError:statusDict[@"msg"]];
            }
        }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查网络连接后重试"];
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"注册信息输入不完整，请补充完整后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
