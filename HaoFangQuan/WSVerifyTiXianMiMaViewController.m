//
//  WSVerifyTiXianMiMaViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/8/19.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSVerifyTiXianMiMaViewController.h"
#import "WSSetTiXianPassWordViewController.h"
#import "WSConfigPhoneViewController.h"
#import "MuseHeader.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
@interface WSVerifyTiXianMiMaViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property(strong,nonatomic)UITextField *passwordTF;
@property(assign,nonatomic)int didInPutLength;
@property(strong,nonatomic)NSMutableArray *addImageViewArray;
@end

@implementation WSVerifyTiXianMiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)setUpAppearance{
    self.didInPutLength = 0;
    self.addImageViewArray = [NSMutableArray array];
    [self refreshInputBackView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSArray *subIamgeView = [self.inputBackView subviews];
    if (subIamgeView.count>0) {
        for (UIImageView *imageView in subIamgeView) {
            [imageView removeFromSuperview];
        }
    }
    [self setUpAppearance];
}
-(void)refreshInputBackView{
    for (int i = 0; i<5; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((i+1)*40, 0, 1, self.inputBackView.bounds.size.height)];
        label.backgroundColor = [UIColor lightGrayColor];
        [self.inputBackView addSubview:label];
    }
    self.passwordTF = [[UITextField alloc]initWithFrame:CGRectMake(0, 2, 50, 30)];
    self.passwordTF.delegate = self;
    self.passwordTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.passwordTF becomeFirstResponder];
    [self.passwordTF addTarget:self action:@selector(textFieldChangedText:) forControlEvents:UIControlEventEditingChanged];
    [self.inputBackView addSubview:self.passwordTF];
}
//开始输入密码时
-(void)textFieldChangedText :(UITextField*)textField{
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
        //
        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake((textField.text.length - 1)*40.3, 0, 39.5, 36)];
        coverimageView.image = coverImage;
        [self.inputBackView addSubview:coverimageView];
        [self.addImageViewArray addObject:coverimageView];
        self.didInPutLength ++;
        [self startVerifyTiXianMiMa];
    }
}
-(void)startVerifyTiXianMiMa{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    NSString *userLoginToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
    //NSLog(@"loginToken%@",userLoginToken);
    NSString *tiXianMiMa = [self.passwordTF.text md5String];
    NSDictionary *para = @{@"tokenId":userLoginToken,@"pinPassword":tiXianMiMa};
    NSString *ipString = verifyTiXianMiMa;
    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:ipString parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict) {
        NSString *result = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
        //NSLog(@"ret%@",result);
        //NSLog(@"我的消息msg%@",statusDict[@"msg"]);
        if ([result isEqualToString:@"0"]) {
            //跳转到设置密码界面
            WSSetTiXianPassWordViewController *setTiXianVC = [self.storyboard instantiateViewControllerWithIdentifier:@"setTiXianPasswordVC"];
            [self.navigationController showViewController:setTiXianVC sender:nil];
        }else{
            [self.passwordTF resignFirstResponder];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"好房圈提示" message:@"原密码输入错误" delegate:self cancelButtonTitle:@"忘记密码" otherButtonTitles:@"重新输入", nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[MBProgressHUD showError:@"请检查网络连接后重试"];
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
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.passwordTF resignFirstResponder];
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            //[self.passwordTF resignFirstResponder];
            //[self.navigationController popViewControllerAnimated:YES];
            WSConfigPhoneViewController *configVC = [self.storyboard instantiateViewControllerWithIdentifier:@"configCodeVC"];
            configVC.subJectWords = @"找回提现密码";
            //NSString *phoneNum = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginPhone"];
            //configVC.alertWords = [NSString stringWithFormat:@"找回提现密码需要短信验证，验证码发送至手机%@,请按提示操作",phoneNum];
            [self.navigationController showViewController:configVC sender:nil];

            break;
        }
        case 1:{
            NSArray *subIamgeView = [self.inputBackView subviews];
            if (subIamgeView.count>0) {
                for (UIImageView *imageView in subIamgeView) {
                    [imageView removeFromSuperview];
                }
            }
            self.passwordTF.text = @"";
            [self setUpAppearance];
            break;
        }
        default:
            break;
    }
}
@end
