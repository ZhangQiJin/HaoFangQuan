//
//  WSrootViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/4/27.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSrootViewController.h"
#import "Header.h"
#import "WSLoginViewController.h"
@interface WSrootViewController ()<UITabBarControllerDelegate>

@property (nonatomic, strong) UIButton *selectedBtn;
@property(strong,nonatomic)UIImageView *selectIndexImageView;
@end

@implementation WSrootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
}
#define BOTTOM_SELECT_BACK_HEIGHT 48
-(void)setUpAppearance{
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    [defa setBool:YES forKey:@"whetherFirstLanch"];
    [defa synchronize];
    self.tabBar.hidden = YES;
    //self.hidesBottomBarWhenPushed = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.selectedBackView = [[UIView alloc]initWithFrame:CGRectMake(0, LCDH-BOTTOM_SELECT_BACK_HEIGHT, LCDW, BOTTOM_SELECT_BACK_HEIGHT)];
    self.selectedBackView.backgroundColor = [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0];
    [self.view addSubview:self.selectedBackView];
    
    for (int i = 0  ; i<self.viewControllers.count; i++) {
        UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        selectButton.tag = i;
        if (selectButton.tag == 0) {
            UIImage *firstPageImage = [UIImage imageNamed:@"shouYeNormal"];
            UIImage *firstPageImageHl = [UIImage imageNamed:@"shouYeSelected"];
            [selectButton setImage:firstPageImage forState:UIControlStateNormal];
            [selectButton setImage:firstPageImageHl forState:UIControlStateSelected];
        }else if (selectButton.tag == 1){
            UIImage *taoImage = [UIImage imageNamed:@"fangYuanBarNormal"];
            UIImage *taoImageHl = [UIImage imageNamed:@"fangYuanBarSelected"];
            [selectButton setImage:taoImage forState:UIControlStateNormal];
            [selectButton setImage:taoImageHl forState:UIControlStateSelected];
        }else if (selectButton.tag == 2){
            UIImage *shopCarImage = [UIImage imageNamed:@"qianBaoNormal"];
            UIImage *shopCarImageHl = [UIImage imageNamed:@"qianBaoSelected"];
            [selectButton setImage:shopCarImage forState:UIControlStateNormal];
            [selectButton setImage:shopCarImageHl forState:UIControlStateSelected];
        }else if (selectButton.tag == 3){
            UIImage *myImage = [UIImage imageNamed:@"woDeBarNormal"];
            UIImage *myImageHl = [UIImage imageNamed:@"woDeBarSelected"];
            [selectButton setImage:myImage forState:UIControlStateNormal];
            [selectButton setImage:myImageHl forState:UIControlStateSelected];
        }
        [selectButton addTarget:self action:@selector(switchToCurrentPage:) forControlEvents:UIControlEventTouchUpInside];
        selectButton.frame = CGRectMake(20+i*(45+35),0, 40, 50);
        [self.selectedBackView addSubview:selectButton];
        if (0 == i) {
            selectButton.selected = YES;
            self.selectedBtn = selectButton;  //设置该按钮为选中的按钮
        }
    }
}

-(void)switchToCurrentPage :(UIButton*)sender
{
    UIButton *currentButton = (UIButton*)sender;
    //1.先将之前选中的按钮设置为未选中
//    self.selectedBtn.selected = NO;
//    //2.再将当前按钮设置为选中
//    currentButton.selected = YES;
//    //3.最后把当前按钮赋值为之前选中的按钮
//    self.selectedBtn = currentButton;
//    //4.跳转到相应的视图控制器. (通过selectIndex参数来设置选中了那个控制器)
//    self.selectedIndex = currentButton.tag;
    //判断是否登录
    if ((currentButton.tag == 2) || (currentButton.tag == 3)) {
        BOOL loginState = [[NSUserDefaults standardUserDefaults]boolForKey:@"whetherlogin"];
        if (loginState) {
             self.selectedBtn.selected = NO;
            currentButton.selected = YES;
            self.selectedBtn = currentButton;
            self.selectedIndex = currentButton.tag;
        }else{
            WSLoginViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:loginVC];
            //[self showViewController:navi sender:nil];
            [self showDetailViewController:navi sender:nil];
        }
    }else{
        self.selectedBtn.selected = NO;
        currentButton.selected = YES;
        self.selectedBtn = currentButton;
        self.selectedIndex = currentButton.tag;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    self.hidesBottomBarWhenPushed = YES;
//}


@end
