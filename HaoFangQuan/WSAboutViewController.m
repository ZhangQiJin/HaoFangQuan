//
//  WSAboutViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSAboutViewController.h"
#import "WSrootViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "WSPersonalSetingViewController.h"
#import "WSLoginViewController.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "WSmyCustomerViewController.h"
#import "WSmyTeamViewController.h"
#import "WSmyCollectionViewController.h"
#import "WSmyMessageViewController.h"
@interface WSAboutViewController ()
- (IBAction)jumpToMyCustomer:(id)sender;
- (IBAction)jumpToMyTeamVC:(id)sender;
- (IBAction)jumpToMyCollectionVC:(id)sender;
- (IBAction)jumpToMyMessageVC:(id)sender;
@property(copy,nonatomic)NSString *userCity;
@property(copy,nonatomic)NSString *userProvice;
@end

@implementation WSAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = YES;
    //[self receiveUserInfoFromServer];
    [self setUpAppearance];
}
#define imageHeadUrl @"http://120.25.153.217"
-(void)receiveUserInfoFromServer{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSDictionary *para = @{@"tokenId":userLoginToken};
    NSString *ipString = receiveUserInfo;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        //[MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"userStatus%@",statusDict);
        //NSLog(@"ret%@",result);
        if ([result isEqualToString:@"0"]) {
            //NSLog(@"msg%@",statusDict[@"msg"]);
//            NSLog(@"userName%@",statusDict[@"userName"]);
//            NSLog(@"phoneNum%@",statusDict[@"phoneNum"]);
//            NSLog(@"portrait%@",statusDict[@"portrait"]);
            self.nameLabel.text = [NSString stringWithFormat:@"%@",statusDict[@"userName"]];
            self.userIDLabel.text = [NSString stringWithFormat:@"%@",statusDict[@"phoneNum"]];
            self.userCity = statusDict[@"city"];
            self.userProvice = statusDict[@"province"];
            //NSLog(@"%@ %@",self.userCity,self.userProvice);
            NSString *headImageUrl = statusDict[@"portrait"];
            if ((headImageUrl.length>5)&&(![headImageUrl isKindOfClass:[NSNull class]])) {
                headImageUrl = [imageHeadUrl stringByAppendingString:headImageUrl];
                [self.headImagView sd_setImageWithURL:[NSURL URLWithString:headImageUrl] placeholderImage:[UIImage imageNamed:@"120"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
            }
            NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
            [defa setObject:self.nameLabel.text forKey:@"userName"];
            [defa synchronize];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD hideHUD];
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
    }];
}

-(void)setUpAppearance{
    self.headImagView.layer.cornerRadius = 35.0f;
    self.headImagView.layer.masksToBounds = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = NO;
    
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (!loginState) {
        self.nameLabel.text = @"亲您还没有登录";
        self.userIDLabel.text = @"";
        self.headImagView.image = [UIImage imageNamed:@"120"];
    }else{
        [self receiveUserInfoFromServer];
        NSString *headImgUrl = [[NSUserDefaults standardUserDefaults]valueForKey:@"myHeadImageUrl"];
        if (headImgUrl.length>0) {
            NSString *imageUrl = [imageHeadUrl stringByAppendingString:headImgUrl];
            imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [self.headImagView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"fullRound"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
        }else{
            self.headImagView.image = [UIImage imageNamed:@"fullRound"];
        }
    }
}
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //UINavigationController *naiv = (UINavigationController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    WSrootViewController*tabBarVC =self.navigationController.childViewControllers[0];
    tabBarVC.selectedBackView.hidden = YES;
    if ([segue.identifier isEqualToString:@"changeUserInfoSegue"]) {
        WSPersonalSetingViewController *infoVC = segue.destinationViewController;
        infoVC.passedName = self.nameLabel.text;
        infoVC.passedPhone = self.userIDLabel.text;
//        if ((self.userCity != nil)&&(self.userProvice != nil)) {
//            infoVC.passedArea = [self.userProvice stringByAppendingString:self.userCity];
//        }
    }
}
- (IBAction)shareToFriends:(id)sender {
    UIImage *iconImage = [UIImage imageNamed:@"80.png"];
    [UMSocialSnsService presentSnsIconSheetView:self
                        appKey:@"559ce95467e58e7bbc002184"
                                      shareText:@"成功下载，注册好房圈，输入推荐人手机号，即可获得1元奖励"
                                     shareImage:iconImage
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToQQ,UMShareToQzone,UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,UMShareToEmail,nil]
                                       delegate:nil];
    [UMSocialData defaultData].extConfig.title = @"好房圈";
}

- (IBAction)jumpUserInfoOrLoginVC:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        WSPersonalSetingViewController *userSettingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userInfoVC"];
        userSettingVC.passedPhone = self.userIDLabel.text;
        userSettingVC.passedName = self.nameLabel.text;
        if ((self.userCity != nil)&&(self.userProvice != nil)) {
            userSettingVC.passedArea = [self.userProvice stringByAppendingString:self.userCity];
        }
        [self.navigationController showViewController:userSettingVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        //[self showViewController:navi sender:nil];
        [self showDetailViewController:navi sender:nil];
    }
}
- (IBAction)jumpToMyCustomer:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        WSmyCustomerViewController *mycustomerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myCustomersVC"];
        [self.navigationController showViewController:mycustomerVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        //[self showViewController:navi sender:nil];
        [self showDetailViewController:navi sender:nil];
    }
}

- (IBAction)jumpToMyTeamVC:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        WSmyTeamViewController *myteamVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myTeamVC"];
        [self.navigationController showViewController:myteamVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        //[self showViewController:navi sender:nil];
        [self showDetailViewController:navi sender:nil];
    }
}

- (IBAction)jumpToMyCollectionVC:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        WSmyCollectionViewController *myCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myCollectVC"];
        [self.navigationController showViewController:myCollectionVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        //[self showViewController:navi sender:nil];
        [self showDetailViewController:navi sender:nil];
    }
}

- (IBAction)jumpToMyMessageVC:(id)sender {
    BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
    if (loginState) {
        WSmyMessageViewController *myMessageVC = [self.storyboard instantiateViewControllerWithIdentifier:@"myMessageVC"];
        [self.navigationController showViewController:myMessageVC sender:nil];
    }else{
        WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
        //[self showViewController:navi sender:nil];
        [self showDetailViewController:navi sender:nil];
    }
}
@end
