//
//  WSChangePhoneViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSChangePhoneViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSChangePhoneViewController ()<UITextFieldDelegate>

@end

@implementation WSChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.orginPhoneLabel.text = self.passedPhone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.phoneTF) {
        self.deleteButton.hidden = NO;
    }else{
        self.deleteButton.hidden = NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.phoneTF) {
        self.deleteButton.hidden = YES;
        if (!(textField.text.length == 11)) {
            self.phoneTF.text = @"";
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"手机号码格式错误，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            if (self.orginPhoneLabel.text == nil) {
                self.orginPhoneLabel.text = textField.text;
            }
        }
    }else{
        self.deleteButton.hidden = YES;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)clearPhoneTF:(id)sender {
    self.phoneTF.text = @"";
}

- (IBAction)finishChangePhoneNum:(id)sender {
//    [self.delegate  changePhoneViewControllerFinishEditWithChangedPhone:self.phoneTF.text];
//    [self.navigationController popViewControllerAnimated:YES];
    //向服务器发送更改后的电话
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"phoneNum":self.orginPhoneLabel.text,@"newPhoneNum":self.phoneTF.text};
    NSString *ipString = changePhoneNumber;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"msg%@",statusDict[@"msg"]);
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.delegate  changePhoneViewControllerFinishEditWithChangedPhone:self.phoneTF.text];
            NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
            [defau setObject:self.phoneTF.text forKey:@"loginPhone"];
            [defau synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD hideHUD];
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
