//
//  WSConfirmSettingTiXianMiMaViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSConfirmSettingTiXianMiMaViewController.h"
#import "WSMyPocketViewController.h"
#import "AFNetworking.h"
#import "MuseHeader.h"
#import "MBProgressHUD+MJ.h"
#import "NSString+Hash.h"
@interface WSConfirmSettingTiXianMiMaViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField *passwordTF;
@property(assign,nonatomic)int didInPutLength;
@property(strong,nonatomic)NSMutableArray *addImageViewArray;
@end

@implementation WSConfirmSettingTiXianMiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpAppearance];
}
-(void)setUpAppearance{
    self.didInPutLength = 0;
    self.addImageViewArray = [NSMutableArray array];
    [self refreshInputBackView];
}
-(void)refreshInputBackView{
    for (int i = 0; i<5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*40, 0, 1, self.inputBackView.bounds.size.height)];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.inputBackView addSubview:label];
    }
    self.passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, 50, 30)];
    self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordTF becomeFirstResponder];
    self.passwordTF.delegate = self;
    [self.passwordTF addTarget:self action:@selector(textFieldChangedText:) forControlEvents:UIControlEventEditingChanged];
    [self.inputBackView addSubview:self.passwordTF];
}
//开始输入密码时
-(void)textFieldChangedText :(UITextField*)textField{
    //NSLog(@"BFtextLenth%ld",textField.text.length);
    //NSLog(@"BFtext%@",textField.text);
    if (textField.text.length<6) {
        if (textField.text.length>self.didInPutLength) {
            self.didInPutLength ++;
            UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
            UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake((textField.text.length - 1)*40.3, 0, 39.5, 36)];
            coverimageView.image = coverImage;
            [self.inputBackView addSubview:coverimageView];
            [self.addImageViewArray addObject:coverimageView];
        }else{
            //UIImageView *imageView =(UIImageView*) [self.addImageViewArray lastObject];
            NSArray *subIamgeView = [self.inputBackView subviews];
            UIImageView *lastImageView = [subIamgeView lastObject];
            [lastImageView removeFromSuperview];
            self.didInPutLength --;
        }
    }else if(textField.text.length == 6){
        [self.passwordTF resignFirstResponder];
        //提交密码
        //NSLog(@"editText%@",self.passwordTF.text);
        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake((textField.text.length - 1)*40.3, 0, 39.5, 36)];
        coverimageView.image = coverImage;
        [self.inputBackView addSubview:coverimageView];
        [self.addImageViewArray addObject:coverimageView];
        self.didInPutLength ++;
    }
}

//#pragma textFieldDelegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField.text.length<6) {
//        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
//        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake(textField.text.length*40.3, 0, 39.5, 36)];
//        coverimageView.image = coverImage;
//        [self.inputBackView addSubview:coverimageView];
//        return YES;
//    }else{
//        return NO;
//    }
//}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:self.passedPassword]) {
        self.submitButton.enabled = YES;
        [self.submitButton setBackgroundColor:[UIColor colorWithRed:246.0/255 green:73.0/255 blue:118.0/255 alpha:1]];
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

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitSetting:(id)sender {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSString *orginPassword = self.passwordTF.text;
    NSString *md5Password = [orginPassword md5String];
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pinPassword":md5Password};
    NSString *ipString = setTiXianPassword;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        [MBProgressHUD hideHUD];
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"设置提现密码msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            [MBProgressHUD showSuccess:@"提现密码设置成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
            NSUserDefaults *defal = [NSUserDefaults standardUserDefaults];
            [defal setBool:YES forKey:@"whetherSettedPassword"];
            [defal synchronize];
            NSArray *viewControllers = self.navigationController.viewControllers;
            for (UIViewController*temp in viewControllers) {
                if ([temp isKindOfClass:[WSMyPocketViewController class]]) {
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
        [MBProgressHUD hideHUD];
    }];
}
@end
