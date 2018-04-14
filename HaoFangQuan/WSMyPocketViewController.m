//
//  WSMyPocketViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSMyPocketViewController.h"
#import "WSrootViewController.h"
#import "WSYuETiXianViewController.h"
#import "WSVerifyTiXianMiMaViewController.h"
#import "WSSetTiXianPassWordViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MuseHeader.h"
@interface WSMyPocketViewController ()<UIAlertViewDelegate>

@end

@implementation WSMyPocketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self receiveUserWaletDataFromServer];
    self.navigationController.navigationBarHidden = YES;
}
-(void)receiveUserWaletDataFromServer{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken};
    NSString *ipString = userWallet;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
//            NSLog(@"msg%@",statusDict[@"msg"]);
//            NSLog(@"lastEarn%@",statusDict[@"lastEarn"]);
//            NSLog(@"totalEarn%@",statusDict[@"totalEarn"]);
//            NSLog(@"balance%@",statusDict[@"balance"]);
            self.laseEarnLabel.text = [NSString stringWithFormat:@"%@",statusDict[@"lastEarn"]];
            self.totalEarnLabel.text = [NSString stringWithFormat:@"%@",statusDict[@"totalEarn"]];
            self.availbelMoneyLabel.text =[NSString stringWithFormat:@"%@",statusDict[@"balance"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self receiveUserWaletDataFromServer];
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //UINavigationController *naiv = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = YES;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            //[self.navigationController popViewControllerAnimated:YES];
            break;
        case 1:{
            WSVerifyTiXianMiMaViewController *verifyTiXianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"verifyPwVC"];
            [self.navigationController showViewController:verifyTiXianVC sender:nil];
            break;
        }
        default:
            break;
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
#define lowerLimit 500.0f
- (IBAction)jumpToTiXianPage:(id)sender {
    float avalibleMoney = [self.availbelMoneyLabel.text floatValue];
    if (avalibleMoney<lowerLimit) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您当前可提现余额低于500元，不能提现" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        BOOL whetherSetPassword = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherSettedPassword"];
        if (whetherSetPassword) {
            WSYuETiXianViewController *yuETiXianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"yuETiXianVC"];
            [self.navigationController showViewController:yuETiXianVC sender:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您还未设置提现密码，请设置提现密码后再试" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (IBAction)jumpToTiXianPassWord:(id)sender {
    BOOL whetherSetpw = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherSettedPassword"];
    if (whetherSetpw) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"您已设置过提现密码，是否重新设置？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重新设置", nil];
        [alert show];
    }else{
        WSSetTiXianPassWordViewController *setTiXianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"setTiXianPasswordVC"];
        [self.navigationController showViewController:setTiXianVC sender:nil];
    }
}
@end
