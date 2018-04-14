//
//  WSLoginViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/21.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSLoginViewController.h"
#import "WSUserRegistViewController.h"
#import "WSrootViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
#import "MuseHeader.h"
#import "NSString+Hash.h"
//#import "WSFirstPageViewController.h"
@interface WSLoginViewController ()
- (IBAction)displayPassword:(id)sender;

@end

@implementation WSLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
}

-(void)setUpAppearance{
    self.navigationController.navigationBarHidden = YES;
}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    //self.loginPhoneTextField.text = [defa valueForKey:@"loginPhone"];
    //self.loginPasswordTextField.text = [defa valueForKey:@"loginPassword"];
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
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (IBAction)zhuCeAction:(id)sender {
//    WSUserRegistViewController *regestVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userRegistVC"];
//    [self.navigationController showViewController:regestVC sender:nil];
//    
//    //[self showViewController:regestVC sender:nil];
//}

//- (IBAction)findPasswordAction:(id)sender {
//    
//}
- (IBAction)loginAction:(id)sender {
    if ((self.loginPhoneTextField.text.length>0)&&(self.loginPasswordTextField.text.length>0)) {
    [MBProgressHUD showMessage:@"正在拼命登录中"];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *ipString = userLogin;
    NSString *md5Password = [self.loginPasswordTextField.text md5String];
    NSDictionary *para = @{@"phoneNum":self.loginPhoneTextField.text,@"password":md5Password};
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        //NSLog(@"msg%@",statusDict[@"msg"]);
        //NSLog(@"code%@",statusDict[@"verifyCode"]);
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"登录成功!"];
            NSString *loginToken = [NSString stringWithFormat:@"%@",statusDict[@"tokenId"]];
            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setObject:loginToken forKey:@"userTokenID"];
            [defa setBool:YES forKey:@"whetherlogin"];
            [defa setObject:self.loginPhoneTextField.text forKey:@"loginPhone"];
            [defa setObject:self.loginPasswordTextField.text forKey:@"loginPassword"];
            [defa synchronize];
            //WSFirstPageViewController *firstPage = [self.storyboard instantiateViewControllerWithIdentifier:@"firstPageVC"];
            //[self.navigationController showViewController:firstPage sender:nil];
            if ([self.pushIndex isEqualToString:@"guidePush"]) {
                WSrootViewController *rootTabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarVC"];
                UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:rootTabBar];
                self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:navi animated:YES completion:nil];
            }else{
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            [MBProgressHUD showError:statusDict[@"msg"]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
    }else{
        [self.loginPhoneTextField becomeFirstResponder];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)displayPassword:(id)sender {
    if (self.loginPasswordTextField.secureTextEntry) {
        self.loginPasswordTextField.secureTextEntry = NO;
    }else{
        self.loginPasswordTextField.secureTextEntry = YES;
    }
}
- (IBAction)willInPutPassword:(id)sender {
    [self.loginPasswordTextField becomeFirstResponder];
}

- (IBAction)resignInput:(id)sender {
    [self.loginPasswordTextField resignFirstResponder];
}
@end
