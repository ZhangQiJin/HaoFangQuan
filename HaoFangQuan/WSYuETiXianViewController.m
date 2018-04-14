//
//  WSYuETiXianViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/4.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSYuETiXianViewController.h"
#import "WSWoDeYinHangKaViewController.h"
#import "WSTiXianMiMaViewController.h"

#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSYuETiXianViewController ()<WoDeYinHangKaChooseDelegate,UITextFieldDelegate>
@property(copy,nonatomic)NSString *maxAvailbleMoney;
@property (weak, nonatomic) IBOutlet UIImageView *selectedBankImageView;
@property (weak, nonatomic) IBOutlet UILabel *selectedBankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedBankTailNumLabel;
@property(copy,nonatomic)NSString *selectedCardID;
@end

@implementation WSYuETiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self receiveMoneyDataFromServer];
}

-(void)receiveMoneyDataFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载中..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken};
    NSString *ipString = walletAvalibleMoney;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            self.availableMoneyLabel.text =[NSString stringWithFormat:@"￥%@",statusDict[@"balance"]];
            self.moneyTextField.placeholder = [NSString stringWithFormat:@"本次最多转出%@",statusDict[@"withdrawals"]];
            self.maxAvailbleMoney = [NSString stringWithFormat:@"%@",statusDict[@"withdrawals"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    float currentMoney = [textField.text floatValue];
    float maxMoney = [self.maxAvailbleMoney floatValue];
    if (currentMoney > maxMoney) {
        self.moneyTextField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"提现金额不能超过最大可提现数，请确认后重新输入" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"chooseCardSegue"]) {
        [self.moneyTextField resignFirstResponder];
        WSWoDeYinHangKaViewController *yinHangKaVC = segue.destinationViewController;
        yinHangKaVC.delegate = self;
    }
}
//-(void)woDeYinHangKaDidChooseCardWithName:(NSString *)cardName image:(UIImage *)cardImage andWeiHao:(NSString *)weiHao{
//    self.selectedCardView.hidden = NO;
//    
//}
-(void)woDeYinHangKaDidChooseCardWithName:(NSString *)cardName image:(UIImage *)cardImage andWeiHao:(NSString *)weiHao andBankID:(NSString *)bankID andCardID:(NSString *)cardID{
    int passedBankID = [bankID intValue];
    NSString *imageName = [NSString stringWithFormat:@"bank%d",passedBankID-1];
    self.selectedBankImageView.image = [UIImage imageNamed:imageName];
    self.selectedBankNameLabel.text = cardName;
    self.selectedBankTailNumLabel.text =weiHao;
    self.selectedCardID = cardID;
    self.selectedCardView.hidden = NO;
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)jumpToPasswordInputPage:(id)sender {
    if ((self.moneyTextField.text.length >0)&&(self.selectedCardID != nil)) {
        WSTiXianMiMaViewController *tiXianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"tiXianVC"];
        tiXianVC.bankID = self.selectedCardID;
        tiXianVC.tiXianMoney = self.moneyTextField.text;
        [self.navigationController showViewController:tiXianVC sender:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"提现信息输入不完整，请补充完整后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
