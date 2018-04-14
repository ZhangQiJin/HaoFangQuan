//
//  WSTianJianYinHangKaViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSTianJianYinHangKaViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSTianJianYinHangKaViewController ()<UITextFieldDelegate>

@end

@implementation WSTianJianYinHangKaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *selectedCard = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedBack"];
    if (selectedCard.length>0) {
        self.bankCardDisplayLabel.text = selectedCard;
    }
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

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.clearTextButton.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length >0 ) {
//        self.nextStepButton.enabled = YES;
//        self.nextStepButton.backgroundColor = [UIColor orangeColor];
//    }
    if (textField == self.cardNumberTF) {
        if (textField.text.length<12) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您输入的银行卡号格式有误，请确认后再次输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.cardNumberTF.text = @"";
        }
    }else if(textField == self.phoneTF){
        self.clearTextButton.hidden = YES;
        if (![self isMobileNumber:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您输入的手机号码格式有误，请确认后再次输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.phoneTF.text = @"";
        }
    }else if (textField == self.nameTF){
        if (textField.text.length<2||textField.text.length>8) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名长度只能为2-8个字符,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTF.text = @"";
        }
        if (![self isChinesecharacter:textField.text]) {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"姓名只能为汉字,请重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//            [alert show];
            self.nameTF.text = @"";
        } 
    }
}
- (BOOL)isChinesecharacter:(NSString *)string{
    NSString *regex = @"[\u4e00-\u9fa5][\u4e00-\u9fa5]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject: string];
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.cardNumberTF) {
        if (textField.text.length<19) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
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
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
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
- (IBAction)clearTextContent:(id)sender{
    self.phoneTF.text = @"";
}

- (IBAction)willAddCardNumber:(id)sender {
    [self.cardNumberTF becomeFirstResponder];
}

- (IBAction)didFinishAddCardInfo:(id)sender {
    [self.cardNumberTF resignFirstResponder];
}

- (IBAction)didFinishAddPhoneNumber:(id)sender {
    [self.phoneTF resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)submitAddedBankCard:(id)sender {
    if ((self.nameTF.text.length >0) && (self.cardNumberTF.text.length >0)&&(self.bankCardDisplayLabel.text.length>0)&&(self.phoneTF.text.length>0)) {
        [MBProgressHUD showMessage:@"正在拼命提交..."];
        AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
        mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        mgr.requestSerializer=[AFJSONRequestSerializer serializer];
        NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
        NSString *bankID = [[NSUserDefaults standardUserDefaults]valueForKey:@"selectedID"];
        //NSLog(@"selctedBankID%@",bankID);
        NSDictionary *para = @{@"tokenId":userLoginToken,@"owner":self.nameTF.text,@"cardNum":self.cardNumberTF.text,@"bankId":bankID,@"phoneNum":self.phoneTF.text};
        NSString *ipString = addNewBankCard;
        ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict){
            [MBProgressHUD hideHUD];
            NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
            //NSLog(@"ret%@",result);
            NSLog(@"msg %@",statusDict[@"msg"]);
            if ([result isEqualToString:@"0"]) {
                [MBProgressHUD showSuccess:@"提交成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:@"请检查网络连接后重试"];
        }];
    }else{
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"请完善信息后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alrt show];
    }
}
@end
