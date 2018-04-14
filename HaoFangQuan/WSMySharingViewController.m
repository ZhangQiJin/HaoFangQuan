//
//  WSMySharingViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/16.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSMySharingViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "UMSocial.h"
@interface WSMySharingViewController ()

@end

@implementation WSMySharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearnce];
}
-(void)setUpAppearnce{
    self.receiveShareButton.layer.cornerRadius = 5.0f;
    self.receiveShareButton.layer.masksToBounds = YES;
    self.receiveShareButton.layer.borderWidth = 0.5;
    self.receiveShareButton.layer.borderColor = [[UIColor orangeColor]CGColor];
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

- (IBAction)sharingAction:(id)sender {
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
//    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
//    //NSLog(@"loginToken%@",userLoginToken);
//    NSDictionary *para = @{@"tokenId":userLoginToken,@"pageNum":@"0",@"pageSize":@"10"};
//    NSString *ipString = myCustomers;
//    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
//        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
//        //NSLog(@"ret%@",result);
//        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
//        if ([result isEqualToString:@"0"]) {
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        //[MBProgressHUD showError:@"请检查网络连接后重试"];
//    }];
    UIImage *iconImage = [UIImage imageNamed:@"80.png"];
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"559ce95467e58e7bbc002184"
                                      shareText:@"成功下载，注册好房圈，输入推荐人手机号，即可获得1元奖励"
                                     shareImage:iconImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"好房圈";
}

- (IBAction)receiveInvestingCode:(id)sender {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken,@"signup":@"0"};
    NSString *ipString = receiveInvestCode;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"邀请码msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            self.sharingCodeLabel.text = statusDict[@"inviteCode"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}
@end
