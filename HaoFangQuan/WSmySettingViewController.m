//
//  WSmySettingViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/28.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSmySettingViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WSLoginViewController.h"
@interface WSmySettingViewController ()<UIAlertViewDelegate>
@property(strong,nonatomic)UIWebView *phoneCallWebView;
@end

@implementation WSmySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    int memory = arc4random()%50;
//    float fMemory = memory/10.0;
//    self.memoryDisplayLabel.text = [NSString stringWithFormat:@"%.1lfM",fMemory];
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

- (IBAction)logOut:(id)sender {
    NSUserDefaults *defal = [NSUserDefaults standardUserDefaults];
    [defal setBool:NO forKey:@"whetherlogin"];
    //[defal setBool:NO forKey:@"whetherSettedPassword"];
    [defal setObject:@"" forKey:@"userHeadImage"];
    [defal setObject:@"" forKey:@"loginPhone"];
    [defal setObject:@"" forKey:@"loginPassword"];
    [defal setObject:@"" forKey:@"myHeadImageUrl"];
    [defal synchronize];
    
//    for (UIViewController *tempVC in self.navigationController.viewControllers) {
//        if ([tempVC isMemberOfClass:[WSLoginViewController class]]) {
//            [self.navigationController popToViewController:tempVC animated:YES];
//        }
//    }
    WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    [self presentViewController:loginVC animated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)customerCall:(id)sender {
    NSString *telNum =self.servicePhoneLaebl.text; //@"400-324324-324";
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",telNum]];
    if ( !self.phoneCallWebView ) {
        self.phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [self.phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
- (IBAction)clearMemory:(id)sender {
    //int memory = arc4random()%50;
    //float fMemory = memory/10.0;
    NSString *currentMemory = [NSString stringWithFormat:@"您将清除所有缓存?"];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:currentMemory delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [MBProgressHUD showMessage:@"正在清理缓存..."];
        [self performSelector:@selector(stopClear) withObject:nil afterDelay:5.0f];
    }
}
-(void)stopClear{
    //self.memoryDisplayLabel.text = @"0.0M";
    [MBProgressHUD hideHUD];
}
@end
