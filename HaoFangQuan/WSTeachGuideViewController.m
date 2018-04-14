//
//  WSTeachGuideViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/7/8.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSTeachGuideViewController.h"
#import "WSrootViewController.h"
#import "WSLoginViewController.h"
#import "WSUserRegistViewController.h"
@interface WSTeachGuideViewController ()

@end

@implementation WSTeachGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
}
#define View_Width self.view.bounds.size.width
#define View_Height self.view.bounds.size.height
-(void)setUpAppearance{
    self.teachScrollView.contentSize = CGSizeMake(3*self.view.bounds.size.width, self.view.bounds.size.height);
    for (int i = 0; i<3; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*View_Width, 0, View_Width, View_Height)];
        [self.teachScrollView addSubview:imageView];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guide%d.jpg",i+1]];
        if (i == 2) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToRootVC:)];
            [imageView addGestureRecognizer:tapGR];
        }
        [self.teachScrollView addSubview:imageView];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)jumpToRootVC :(UITapGestureRecognizer*)tapGR{
    WSrootViewController *rootTabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarVC"];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:rootTabBar];
    self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:navi animated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)jumpToRegistVC:(id)sender {
    WSUserRegistViewController *userRegistVC = [self.storyboard instantiateViewControllerWithIdentifier:@"userRegistVC"];
    //[self presentViewController:userRegistVC animated:YES completion:nil];
    //UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:userRegistVC];
    //[self.navigationController showViewController:userRegistVC sender:nil];
    userRegistVC.pushIndex = @"guidePage";
    [self presentViewController:userRegistVC animated:YES completion:nil];
}

- (IBAction)jumpToLoginPage:(id)sender {
    WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.pushIndex = @"guidePush";
    [self presentViewController:loginVC animated:YES completion:nil];
    //[self.navigationController showDetailViewController:loginVC sender:nil];
}
@end
