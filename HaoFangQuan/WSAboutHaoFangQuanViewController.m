//
//  WSAboutHaoFangQuanViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/10.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSAboutHaoFangQuanViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
@interface WSAboutHaoFangQuanViewController ()

@end

@implementation WSAboutHaoFangQuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.aboutHaoFangQuanWebview.scalesPageToFit = YES;
    [self receiveUrlFromServer];
}
#define imageHeadUrl @"http://120.25.153.217"
-(void)receiveUrlFromServer{
    [MBProgressHUD showMessage:@"正在拼命加载..."];
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    //NSDictionary *para = @{@"tokenId":userLoginToken,@"id":currentModel.ID};
    NSString *ipString = aboutHaoFangQuan;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"关于好房圈msg%@",statusDict[@"msg"]);
            //NSLog(@"关于好房圈url%@",statusDict[@"url"]);
            NSString *secondPath = [NSString stringWithFormat:@"%@",statusDict[@"url"]];
            NSString *targetPath = [imageHeadUrl stringByAppendingString:secondPath];
            NSURL *url = [NSURL URLWithString:targetPath];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.aboutHaoFangQuanWebview loadRequest:request];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
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
@end
