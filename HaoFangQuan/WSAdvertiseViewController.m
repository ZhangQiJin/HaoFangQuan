//
//  WSAdvertiseViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/7/8.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSAdvertiseViewController.h"

#import "WSrootViewController.h"
#import "WSTeachGuideViewController.h"
@interface WSAdvertiseViewController ()

@end

@implementation WSAdvertiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setUpAppearance];
    NSURL *url = [NSURL URLWithString:@"http://120.25.153.217/uploads/welcome.png"];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    self.adverImageView.image = [UIImage imageWithData:imageData];
    //NSLog(@"%@",self.adverImageView.image);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUpAppearance];
}
-(void)setUpAppearance{
    [self performSelector:@selector(jumpToTargetVC) withObject:nil afterDelay:3.0f];
}
-(void)jumpToTargetVC{
    BOOL whetherFirstLanch = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherFirstLanch"];
    if (whetherFirstLanch) {
        WSrootViewController *rootTabBar = [self.storyboard instantiateViewControllerWithIdentifier:@"rootTabBarVC"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:rootTabBar];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:navi animated:YES completion:nil];
    }else{
        WSTeachGuideViewController *teachVC = [self.storyboard instantiateViewControllerWithIdentifier:@"teachVC"];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:teachVC animated:YES completion:nil];
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

@end
