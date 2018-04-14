//
//  WSSetTiXianPassWordViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/6/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSSetTiXianPassWordViewController.h"
#import "WSConfirmSettingTiXianMiMaViewController.h"
@interface WSSetTiXianPassWordViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UITextField *passwordTF;
@property(assign,nonatomic)int didInPutLength;
@property(strong,nonatomic)NSMutableArray *addImageViewArray;
@end

@implementation WSSetTiXianPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self setUpAppearance];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake((textField.text.length - 1)*40.3, 0, 39.5, 36)];
        coverimageView.image = coverImage;
        [self.inputBackView addSubview:coverimageView];
        [self.addImageViewArray addObject:coverimageView];
        self.didInPutLength ++;
        //跳转提现密码确认界面
        WSConfirmSettingTiXianMiMaViewController *confirmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmTiXianMiMaSettingVC"];
        confirmVC.passedPassword = self.passwordTF.text;
        [self.navigationController showViewController:confirmVC sender:nil];
    }
}
//#pragma textFieldDelegate
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSLog(@"BFtextLenth%ld",textField.text.length);
//    NSLog(@"BFtext%@",textField.text);
//    if (textField.text.length<6) {
//        UIImage *coverImage = [UIImage imageNamed:@"passWordCover.png"];
//        UIImageView *coverimageView = [[UIImageView alloc]initWithFrame:CGRectMake(textField.text.length*40.3, 0, 39.5, 36)];
//        coverimageView.image = coverImage;
//        [self.inputBackView addSubview:coverimageView];
//        return YES;
//    }else if(textField.text.length == 6){
//        //跳转提现密码确认界面
//        WSConfirmSettingTiXianMiMaViewController *confirmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmTiXianMiMaSettingVC"];
//        confirmVC.passedPassword = self.passwordTF.text;
//        [self.navigationController showViewController:confirmVC sender:nil];
//        return YES;
//    }else{
//        return NO;
//    }
//}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.text.length == 6) {
//        //跳转提现密码确认界面
//        WSConfirmSettingTiXianMiMaViewController *confirmVC = [self.storyboard instantiateViewControllerWithIdentifier:@"confirmTiXianMiMaSettingVC"];
//        confirmVC.passedPassword = self.passwordTF.text;
//        [self.navigationController showViewController:confirmVC sender:nil];
//    }
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
    [self.view endEditing:YES];
}
- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
