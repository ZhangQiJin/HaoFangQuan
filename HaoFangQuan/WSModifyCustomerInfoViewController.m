//
//  WSModifyCustomerInfoViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSModifyCustomerInfoViewController.h"
#import "MuseHeader.h"
#import "AFNetworking.h"
#import "MBProgressHUD+MJ.h"
@interface WSModifyCustomerInfoViewController ()
@property(copy,nonatomic)NSString *sex;
@end

@implementation WSModifyCustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.nameTextField.text = self.passedModel.name;
    self.phoneTextField.text = self.passedModel.phone;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeSex:(id)sender {
    UIButton *currentButton = sender;
    currentButton.selected = YES;
    if (currentButton.tag == 25) {
        self.femalButton.selected = NO;
        self.sex = @"男";
    }else{
        self.maleButton.selected = NO;
        self.sex = @"女";
    }
}

- (IBAction)turnBack:(id)sender {
//    [MBProgressHUD showMessage:@"正在拼命提交..."];
//    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
//    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
//    NSString *userLoginToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"userTokenID"];
//    NSLog(@"loginToken%@",userLoginToken);
//    NSDictionary *json = @{@"tokenId":userLoginToken,@"name":self.nameTextField.text,@"phoneNum":self.phoneTextField.text,@"purpose":self.purposeLabel.text,@"apartment":self.houseTypeLabel.text,@"priceRange":self.priceRangeLabel.text};
//    NSDictionary *para = [NSDictionary dictionary];
//    para = @{@"json" :json};
//    NSString *ipString = addCustomers;
//    ipString = [ipString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    [mgr POST:ipString parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        if (self.headImageView.image != nil) {
//            NSLog(@"image%@",self.headImageView.image);
//            NSData *data = UIImageJPEGRepresentation(self.headImageView.image , 0.5);
//            //拼接文件参数
//            [formData appendPartWithFileData:data name:@"file" fileName:@"customerHead.jpg" mimeType:@"image/jpeg"];
//        }
//    } success:^(AFHTTPRequestOperation *operation, NSDictionary *statusDict){
//        [MBProgressHUD hideHUD];
//        NSString *respond = [NSString stringWithFormat:@"%@",statusDict[@"ret"]];
//        //        NSLog(@"respond%@",respond);//responseObject);
//        if ([respond isEqualToString:@"0"]) {
//            //[MBProgressHUD showSuccess:@"添加成功"];
//            [self.navigationController popViewControllerAnimated:YES];
//        }else{
//            [MBProgressHUD showError:statusDict[@"msg"]];
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"提交失败"];
//    }];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
