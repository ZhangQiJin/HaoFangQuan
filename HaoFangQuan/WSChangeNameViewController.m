//
//  WSChangeNameViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSChangeNameViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSChangeNameViewController ()<UITextFieldDelegate>

@end

@implementation WSChangeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.orginNameLabel.text = self.passedName;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.nameTF) {
        self.deleteButton.hidden = NO;
    }else{
        self.deleteButton.hidden = NO;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.nameTF) {
        self.deleteButton.hidden = YES;
        if (textField.text.length<2||textField.text.length>8) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名长度只能为2-8个字符,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            self.nameTF.text = @"";
        }
        if (![self isChinesecharacter:textField.text]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名只能为汉字,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alert show];
            self.nameTF.text = @"";
        }
    }else{
        self.deleteButton.hidden = YES;
    }
}
- (BOOL)isChinesecharacter:(NSString *)string{
    if (string.length == 0) {
        return NO;    }
    unichar c = [string characterAtIndex:0];
    if (c >=0x4E00 && c <=0x9FA5){
        return YES;//汉字
    }else{
        return NO;//英文
    }}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
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

- (IBAction)finishChangeName:(id)sender {
    if (self.nameTF.text.length>=2) {
    [self.delegate  changeNameViewControllerFinishEditWithChangedName:self.nameTF.text];
    [self.navigationController popViewControllerAnimated:YES];
    //向服务器发送更改后的姓名
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"userName":self.nameTF.text};
    NSString *ipString = changeMyName;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"msg%@",statusDict[@"msg"]);
            [MBProgressHUD showSuccess:@"修改成功"];
            NSUserDefaults *defau = [NSUserDefaults standardUserDefaults];
            [defau setObject:self.nameTF.text forKey:@"userName"];
            [defau synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];}else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名不能为空" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
        self.nameTF.text = @"";
    }
}

- (IBAction)clearNameTF:(id)sender {
    self.nameTF.text = @"";
}

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
