//
//  WSCustomerInfoViewController.m
//  HaoFangQuan
//
//  Created by Muse on 15/5/5.
//  Copyright (c) 2015年 Muse. All rights reserved.
//

#import "WSCustomerInfoViewController.h"
#import "WSCheckStatusDetailViewController.h"
//#import "WSModifyCustomerInfoViewController.h"
#import "WSAddCustomerViewController.h"
#import "UIImageView+WebCache.h"
@interface WSCustomerInfoViewController ()

@end

@implementation WSCustomerInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define imageHeadUrl @"http://120.25.153.217"
-(void)viewWillAppear:(BOOL)animated{
    self.nameLabel.text = self.passedModel.name;
    self.phoneLabel.text = self.passedModel.phone;
    self.purpersLabel.text = self.passedModel.purpose;
    self.apartmentLabel.text = self.passedModel.apartMent;
    self.priceRangLabel.text = self.passedModel.priceRange;
    
    self.headImageView.layer.cornerRadius = 30.0f;
    self.headImageView.layer.masksToBounds = YES;
    //NSString *headImgUrl = [[NSUserDefaults standardUserDefaults]valueForKey:@"myHeadImageUrl"];
    NSString *headImgUrl = self.passedModel.imgUrl;
    NSString *imageUrl = imageHeadUrl;
    if (headImgUrl != nil) {
        imageUrl = [imageHeadUrl stringByAppendingString:headImgUrl];
    }
    imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"aboutMeHeadDefau"] options:SDWebImageLowPriority | SDWebImageRetryFailed];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"checkGouFangZhuanTaiSegue"]) {
        WSCheckStatusDetailViewController *checkDetaiStatusVC = segue.destinationViewController;
        checkDetaiStatusVC.passedID = self.passedModel.ID;
    }
}

- (IBAction)turnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)jumpToModifyCustomerInfoVC:(id)sender {
    WSAddCustomerViewController *modifyCustomerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addCustomerVC"];
    modifyCustomerVC.passedModel = self.passedModel;
    modifyCustomerVC.showIndex = @"modify";
    [self.navigationController showViewController:modifyCustomerVC sender:nil];
}
@end
